module ZeroReg(output reg out);
  initial out = 1'b0; // Initialize output to zero
  // No updates to 'out' happen; it remains zero
endmodule

module TopModule(output out);
  ZeroReg u0(.out(out));
endmodule