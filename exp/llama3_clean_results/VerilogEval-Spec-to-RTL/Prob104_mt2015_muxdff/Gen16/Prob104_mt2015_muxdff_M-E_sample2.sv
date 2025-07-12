module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  input c1, // Control signal 1
  input c2, // Control signal 2
  output reg Q
);

  always @(posedge clk) begin
    if (L) begin
      Q <= r_in;
    end else begin
      case ({c1, c2})
        2'b00: Q <= q_in; // Pass through
        2'b01: Q <= q_in ^ 1'b1; // XOR with 1
        2'b10: Q <= q_in & 1'b1; // AND with 1
        2'b11: Q <= q_in ^ q_in; // XOR with itself
      endcase
    end
  end

endmodule