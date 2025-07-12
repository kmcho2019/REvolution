module TopModule(input wire in, output wire out);
  // Localparam alias to indicate wire passthrough intent without overhead
  localparam wire_passthrough = 1'b1;
  assign out = in & wire_passthrough;
endmodule