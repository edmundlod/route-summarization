%{!?pkg_version: %global pkg_version 0.3.1}

Name:           route-summarization
Version:        %{pkg_version}
Release:        1%{?dist}
Summary:        IP route summarization and CIDR aggregation tool
License:        BSD-3-Clause
URL:            https://github.com/edmundlod/route-summarization
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

Requires:       perl(Net::CIDR::Lite)
Requires:       perl(Getopt::Long)

%description
Reads IPv4 and IPv6 networks one per line from stdin and outputs a
summarized, aggregated list of CIDR blocks. Supports an optional --spf
mode for parsing SPF prefix notation, as used by postallow.

%prep
%autosetup

%build
# nothing to build — pure Perl script

%install
install -D -m 755 aggregateCIDR.pl %{buildroot}%{_bindir}/aggregateCIDR.pl

%files
%license LICENSE
%doc README.md
%{_bindir}/aggregateCIDR.pl

%changelog
* Sat Apr 11 2026 Edmund Lodewijks <edmund@proteamail.com> - 0.3.1-1
- Initial RPM packaging
