module TopModule (
  input clk,
  input L,
  input [1:0] select, // 2-bit select signal to determine the update rule
  input q_in,
  input r_in,
  output reg Q
);

  always @(posedge clk) begin
    if (L) begin
      Q <= r_in;
    end else begin
      case (select)
        2'b00: Q <= q_in; // For the second bit, simple assignment
        2'b01: Q <= q_in; // For the third bit, simple assignment
        2'b10: Q <= q_in ^ r_in; // For the first bit, XOR operation
        default: Q <= 1'b0; // Default case, set Q to 0
      endcase
    end
  end

endmodule