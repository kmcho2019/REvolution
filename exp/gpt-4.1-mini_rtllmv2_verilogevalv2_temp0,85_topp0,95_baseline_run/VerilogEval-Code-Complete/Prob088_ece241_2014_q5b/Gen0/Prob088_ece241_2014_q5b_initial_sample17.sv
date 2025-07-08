module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // State encoding (one-hot)
  reg A, B;

  // State register with asynchronous active-high reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      A <= 1'b1;
      B <= 1'b0;
    end else begin
      case (1'b1)
        A: begin
          if (x == 1'b0) begin
            A <= 1'b1;
            B <= 1'b0;
          end else begin
            A <= 1'b0;
            B <= 1'b1;
          end
        end
        B: begin
          // Remain in B regardless of input
          A <= 1'b0;
          B <= 1'b1;
        end
        default: begin
          // Default to A if no state set (safe fallback)
          A <= 1'b1;
          B <= 1'b0;
        end
      endcase
    end
  end

  // Output combinational logic (Mealy machine)
  always @(*) begin
    if (A) begin
      if (x == 1'b0)
        z = 1'b0;
      else
        z = 1'b1;
    end else if (B) begin
      if (x == 1'b0)
        z = 1'b1;
      else
        z = 1'b0;
    end else begin
      z = 1'b0; // Default output if no state active
    end
  end

endmodule