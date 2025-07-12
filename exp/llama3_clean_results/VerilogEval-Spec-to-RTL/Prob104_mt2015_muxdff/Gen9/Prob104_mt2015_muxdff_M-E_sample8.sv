module TopModule (
  input clk,
  input L,
  input [1:0] op, // Operation selector
  input q_in,
  input r_in,
  output reg Q
);

  always @(posedge clk) begin
    if (L) begin
      Q <= r_in; // Load from r_in when L is asserted
    end else begin
      case (op)
        2'b00: Q <= q_in; // Pass through q_in
        2'b01: Q <= ~q_in; // Invert q_in
        2'b10: Q <= q_in ^ r_in; // XOR of q_in and r_in (example operation)
        default: Q <= 1'b0; // Default to 0 for unknown op
      endcase
    end
  end

endmodule