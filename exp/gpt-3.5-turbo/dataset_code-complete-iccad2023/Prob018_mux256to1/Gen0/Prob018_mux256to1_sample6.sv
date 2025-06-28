module TopModule (
  input [255:0] in,
  input [7:0] sel,
  output reg out
);

always @(*) begin
  case(sel)
    8'd0: out = in[0];
    8'd1: out = in[1];
    8'd2: out = in[2];
    // Continue this pattern for all 256 cases
    // 8'd255: out = in[255];
    default: out = 1'b0; // Default case if none of the above match
  endcase
end

endmodule