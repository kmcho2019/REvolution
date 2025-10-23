module TopModule (
  input clk,
  input L,
  input [1:0] sel, // Select signal to determine operation
  input q_in,
  input r_in,
  output reg Q
);

  reg q_prev; // To hold the previous state of Q
  always @(posedge clk) begin
    q_prev = Q; // Update q_prev with the current state of Q
    if (L) begin
      Q <= r_in; // Load Q with r_in when L is asserted
    end else begin
      case (sel)
        2'b00: Q <= q_in; // Directly assign q_in to Q
        2'b01: Q <= q_prev ^ q_in; // XOR of q_prev and q_in
        2'b10: Q <= q_in ^ q_prev; // Same as above, but for consistency
        2'b11: Q <= q_prev; // Hold the previous state
      endcase
    end
  end

endmodule