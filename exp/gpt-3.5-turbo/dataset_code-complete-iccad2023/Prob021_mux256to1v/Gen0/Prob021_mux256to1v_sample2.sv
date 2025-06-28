module TopModule (
  input [1023:0] in,
  input [7:0] sel,
  output reg [3:0] out
);

always @(*) begin
  case(sel)
    0: out = in[4*sel +: 4]; // select bits in[3:0]
    1: out = in[4*sel +: 4]; // select bits in[7:4]
    2: out = in[4*sel +: 4]; // select bits in[11:8]
    // Continue this pattern for all 256 cases (sel 0 to 255)
    default: out = 4'b0; // Default case
  endcase
end

endmodule