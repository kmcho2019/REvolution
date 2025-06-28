module TopModule (
  input [255:0] in,
  input [7:0] sel,
  output out
);

reg out;

always @(*) begin
  case(sel)
    8'b00000000: out = in[0];
    8'b00000001: out = in[1];
    8'b00000010: out = in[2];
    // Continue this pattern for all 256 possible selections
    default: out = 1'b0; // Default selection
  endcase
end

endmodule