# NixOS: the Ultimate Computing Solution

[NixOS](https://nixos.org/) is an unconventional
[Linux distribution](https://en.wikipedia.org/wiki/Linux_distribution) which
focuses on reproducibility and purity. It uses a unique approach where
everything that comes with a system is described in a declarative configuration
written in the Nix
[functional language](https://en.wikipedia.org/wiki/Functional_programming).
This approach appeals to many enthusiasts, including myself, making NixOS my
distribution of choice for all of my machines.

In the following sections, I am going to explain the reasons why I believe
NixOS is the most versatile option for nearly all use cases.

## Write Once, Use Anywhere

The statement that NixOS uses a declarative configuration to describe the
system may sound confusing at first for someone who has never explored this
distribution before. To keep it simple, let's take a
[Debian](https://www.debian.org/) machine and compare it to a NixOS one.

To install a package, such as [GIMP](https://www.gimp.org/), on Debian, one
would typically run this command:

	# apt install gimp

The package manager will then build the package and install it to the system.

On NixOS, this is different; the recommended approach to install a package is
to update the configuration at `/etc/nixos/configuration.nix`, adding the
package to the specific `environment.systemPackages` option:

	{ config, pkgs, ... }:
	{
		# Other options...

		environment.systemPackages = [
			# Other packages...
			pkgs.gimp
			# Other packages...
		];

		# Other options...
	}

Modifying the configuration file alone does not update the system; it is
necessary to run the following command to apply the changes:

	# nixos-rebuild switch

One may rightfully ask how this process may be considered better than just
running a simple command. In the `/etc/nixos/configuration.nix` file, other
options are being set by default:

	{ config, pkgs, ... }:
	{
		# Other options...

		# Set the host name.
		networking.hostName = "myhost";

		# Set the time zone.
		time.timeZone = "Europe/Rome";

		# Declare the users.
		users.users.myuser = {
			extraGroups = [ "wheel" ];
			isNormalUser = true;
		};

		# Other options...
	}

It is easy to notice how the system is completely described by this file and
all the other files imported from it, which by default include
`hardware-configuration.nix`.

An advantage over conventional methods is the possibility to
[version control](https://en.wikipedia.org/wiki/Version_control) the
configuration and reuse it for other devices. This way we are less dependent
on the physical machine being used and more focused on the operating system
maintenance itself.

Saying that it is possible to *perfect the system once to reuse it at any time
using NixOS* is of course incorrect, since no perfect system exists and the
configuration is going to be changed frequently, especially during its
beginnings; the benefit of this distribution is instead to never do the same
work of configuring a machine again.

## Absence of Bloatware

Due to the fact that every detail of the machine is described and exactly
applied from the configuration files, a NixOS device exactly contains what its
owner decides and nothing more.

While on a conventional Linux system diverse software would be installed during
its lifetime never to be remembered again, on NixOS everything is easily
manageable. That is not only because of the explicit device configuration
which has already been discussed, but also the way the underlying Nix system
handles packages.

Nix is the cross-platform package manager NixOS is based on. It takes a
distinctive approach in managing packages; there are no global shared paths
between them, unlike common package managers which directly install them to the
root file system, and every package resides in a unique isolated build
directory of `/nix/store/`.

After a package is installed in its directory, the Nix package manager proceeds
to create symbolic links pointing to its build artifacts in the places where a
POSIX system would normally find them.

The operation that occurs when a package is removed from the system
configuration and the `nixos-rebuild` command is run, then, should simply
remove the directory containing the package and all the symlinks to it,
preventing conflicts and avoiding bloat from unused dependencies.

Actually, walking through the configuration, the operating system identifies
which packages are needed and marks all the removed ones as removable. It is,
in fact, possible to *garbage collect*; that is, to delete all the unused
packages from the system:

	$ nix-collect-garbage -d

In addition, it is possible to refer to packages inside the configuration
without actually installing them to the system; that means to have them present
in `/nix/store/` but only used, through absolute paths, by the places they are
required by.

The following is an example NixOS module declaring a systemd service which uses
the [suckless quark](https://tools.suckless.org/quark/) web server:

	{ config, pkgs, ... }:
	{
		systemd.services.web = {
			enable = true;
			wantedBy = [ "multi-user.target" ];
			after = [ "network.target" ];
			script = ''
				${pkgs.quark}/bin/quark -p 80 -d /var/www
			'';
			};
		};
	}

For someone new, this snippet may be a lot; but really, the only addition is
the new usage of `pkgs.quark`; it is not contained in a list such as the
`environment.systemPackages` mentioned earlier, it is instead employed inside
a string.

As a matter of fact, `pkgs.quark` evaluates to the *path* of the build
directory of the `quark` package, which is, as stated earlier, a subdirectory
of `/nix/store/`; that means that `"${pkgs.quark}/bin/quark"` is the actual
location of the installed `quark` executable.

It can be seen how no global installation is performed; instead, the package is
installed in `/nix/store/` and is not linked in the root file system. In short,
by taking advantage of the clarity provided by the NixOS configuration system,
any machine will only contain the necessary software in it, reducing bloat to
the bare minimum.

One limitation of the distribution is the inherent dependency on systemd and
the [GNU core utils](https://www.gnu.org/software/coreutils/), which some,
myself included, may consider *bloat*. While it is possible to replace the
core utilities accessible from the shell with any alternative, the GNU ones
always remain installed due to the dependence of other packages. In addition,
[Bash](https://www.gnu.org/software/bash/) is always set as the target of the
`/bin/sh` symbolic link.

In essence, NixOS is a GNU/Linux distribution based on Systemd at its core.
This may be a deal-breaker for some; however, in my opinion, the advantages of
the structure provided by the operating system outweight the disadvantages of
using these large pieces of software.

## Community

NixOS was created after
[its creator](https://en.wikipedia.org/wiki/Armijn_Hemel) proposed applying the
principles of the already-existing Nix package manager to a Linux distribution.
He began the development of the operating system, with its first release in
2013.

In 2015, the [NixOS Foundation](https://nixos.org/community/) was established
to oversee the development and the community of Nix and NixOS. As of today, the
non-profit is still active and supportive towards improvements in the
ecosystem.

NixOS has seen increasing popularity over the years; this may have happened due
to the following reasons:

1. Improvements in the NixOS Software — Over time, the package manager and
   the suite of utilities have progressed to incorporate the essential features
   that makes NixOS as it is today.
2. Growing Interest in the Linux Desktop — Recently, many have been
   *distro-hopping*, trying to find the perfect operating system for their
   needs; those who have settled on NixOS may share some of the reasons
   explored in this article.
3. Constant Expansion of [*Nixpkgs*](https://github.com/NixOS/nixpkgs) — Over
   time, many packages have been released in Nixpkgs, the main package
   repository administered by the NixOS Foundation. In addition, many more
   packages have seen increased maintenance due to the growing number of Nix
   developers and volunteers.

One thing to mention is the lack of good documentation; it is significantly
smaller than, for example, the [Arch Linux](https://archlinux.org/) one, and
the existing manuals are often either incomplete or confusing.

As of today, the NixOS ecosystem is built on a strong foundation and a clear
set of values. A large community has evolved; there are hundreds of active
contributors maintaining the packages. The Nixpkgs repository contains tens of
thousands of up-to-date packages, ranking first among all package repositories.
