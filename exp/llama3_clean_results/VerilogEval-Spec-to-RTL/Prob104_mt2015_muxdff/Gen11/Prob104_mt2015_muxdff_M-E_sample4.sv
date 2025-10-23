module TopModule (
  input clk,
  input L,
  input [1:0] mode, // Mode selector for the TopModule's operation
  input q_in,
  input r_in,
  output reg Q
);

  always @(posedge clk) begin
    if (L) begin
      // Load mode: Always load r_in when L is high
      Q <= r_in;
    end else begin
      case (mode)
        2'b00: Q <= q_in; // Pass-through mode
        2'b01: Q <= Q ^ q_in; // XOR mode
        2'b10: Q <= ~Q; // Invert mode
        default: Q <= Q; // Hold mode
      endcase
    end
  end

endmodule