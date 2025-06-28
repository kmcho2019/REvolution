module TopModule (
  input ring,
  input vibrate_mode,
  output ringer,
  output motor
);
  
  // Use a conditional statement to decide whether to activate the ringer or motor
  assign ringer = (vibrate_mode) ? 0 : ring;
  assign motor = (vibrate_mode) ? 1 : 0;

endmodule