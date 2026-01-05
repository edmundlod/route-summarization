# CIDR Route Summarization

A lightweight CIDR aggregation utility built in Perl using the [`Net::CIDR::Lite`](https://metacpan.org/dist/Net-CIDR-Lite/view/Lite.pm) module. This tool summarizes IPv4 and IPv6 prefixes from standard input and optionally formats output for SPF record usage.

Inspired by the original concept described in [Random Thoughts](http://adrianpopagh.blogspot.com/2008/03/route-summarization-script.html).

---

## Features

* Summarizes IPv4 and IPv6 CIDR prefixes
* Accepts plain IPs (auto-converted to `/32` or IPv6 host equivalents)
* Supports SPF-style `ip4:` / `ip6:` prefix stripping and output
* Gracefully ignores invalid prefixes
* Simple STDIN-driven workflow for pipelines and scripts

---

## Usage

Run interactively:

```bash
$ ./cidr-summarize.pl
Enter IP/Mask one per line (1.2.3.0/24). End with CTRL+D.
```

Or pipe a file into it:

```bash
$ ./cidr-summarize.pl < cidr.txt
```

### Options

```text
--help        Display usage information
--quiet       Suppress non-essential messages
--spf         Enable SPF input parsing and SPF-style output
```

Example with SPF mode:

```bash
$ ./cidr-summarize.pl --spf < spf-list.txt
ip4:203.0.113.0/24
ip6:2001:db8::/48
```

---

## Input Examples

```text
192.0.2.1
192.0.2.0/24
2001:db8:10::/48
ip4:198.51.100.0/25   (with --spf)
```

Invalid or non-CIDR lines are ignored.

---

## Output

The script prints an aggregated list of CIDRs with redundant or overlapping ranges collapsed.
IPv4 host addresses (`/32`) are printed without the mask unless explicitly required.

Example:

```text
192.0.2.0/24
198.51.100.0/24
2001:db8:10::/48
```

---

## Project Integrations

Because this tool consumes input exclusively from STDIN, it embeds cleanly into other automation frameworks such as Bash, Tcl, Python, CI pipelines, Makefile workflows, or any scripting environment.

### Projects using or compatible with this tool

* **Postallow** — [https://codeberg.org/peregrinus13/postallow](https://codeberg.org/peregrinus13/postallow)
* **Postwhite Fork** — [https://github.com/nabbi/postwhite](https://github.com/nabbi/postwhite)
* **TCL IPSet** — [https://github.com/nabbi/tcl-ipset](https://github.com/nabbi/tcl-ipset)

---

## Requirements

* Perl 5
* `Net::CIDR::Lite` module
* `Getopt::Long` (core Perl)

Install module via CPAN:

```bash
cpan install Net::CIDR::Lite
```
