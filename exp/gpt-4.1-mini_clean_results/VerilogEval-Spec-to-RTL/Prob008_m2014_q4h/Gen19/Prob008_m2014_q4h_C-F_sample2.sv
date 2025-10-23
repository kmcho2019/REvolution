module TopModule(input in, output wire out);
  // Internal signal for debug or future instrumentation
  wire internal_signal;
  
  // Combinational assignment to internal signal
  assign internal_signal = in;
  
  // Directly drive output from internal signal
  assign out = internal_signal;
endmodule