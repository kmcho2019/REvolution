module TopModule (
  input ring,
  input vibrate_mode,
  output ringer,
  output motor
);
  
  // Turn on motor if in vibrate mode, otherwise turn on the ringer
  assign motor = (vibrate_mode) ? 1'b1 : 1'b0;
  assign ringer = (vibrate_mode) ? 1'b0 : 1'b1;
  
endmodule