enum IPGEnvironment {
  sandbox,
  live,
}

String getEndpoint(IPGEnvironment? environment) {
  switch (environment) {
    case IPGEnvironment.sandbox:
      return "https://sandboxipgpayment.echeckout.lk/ipg/sandbox";
    case IPGEnvironment.live:
      return "https://ipgpayment.echeckout.lk/ipg/pro";
    case null:
      return "https://sandboxipgpayment.echeckout.lk/ipg/sandbox";
  }
}
