// TopModule drives a constant logic 0 on output 'out'.
// This implementation uses a continuous assignment for minimal area and power.
module TopModule(output out);
  assign out = 1'b0;
endmodule