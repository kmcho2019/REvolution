module TopModule (
  input mode,
  input too_cold,
  input too_hot,
  input fan_on,
  output heater,
  output aircon,
  output fan
);
  
  assign fan = (fan_on) ? 1 : ((mode & too_cold) | (~mode & too_hot)) ? 1 : 0;
  assign heater = (mode & too_cold & ~fan) ? 1 : 0;
  assign aircon = (~mode & too_hot & ~fan) ? 1 : 0;

endmodule