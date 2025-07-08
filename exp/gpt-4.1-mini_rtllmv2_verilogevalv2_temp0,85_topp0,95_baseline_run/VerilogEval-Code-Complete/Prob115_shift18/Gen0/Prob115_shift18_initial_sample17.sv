module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output reg [63:0] q
);

  wire msb = q[63]; // sign bit for arithmetic right shift

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else if (ena) begin
      case (amount)
        2'b00: q <= q << 1; // shift left by 1, fill LSB with 0
        2'b01: q <= q << 8; // shift left by 8, fill LSBs with 0
        2'b10: q <= { {1{msb}}, q[63:1] }; // arithmetic right shift by 1
        2'b11: q <= { {8{msb}}, q[63:8] }; // arithmetic right shift by 8
        default: q <= q; // default case (should not happen)
      endcase
    end
  end

endmodule