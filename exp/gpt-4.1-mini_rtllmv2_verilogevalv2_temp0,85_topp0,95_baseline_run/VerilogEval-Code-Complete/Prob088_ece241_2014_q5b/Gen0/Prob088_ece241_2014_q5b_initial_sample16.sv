module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);
  // One-hot state encoding
  reg state_A, state_B;

  // State transitions
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state_A <= 1'b1;
      state_B <= 1'b0;
    end else begin
      case ({state_A, state_B})
        2'b10: begin // State A
          if (x)
            begin state_A <= 1'b0; state_B <= 1'b1; end
          else
            begin state_A <= 1'b1; state_B <= 1'b0; end
        end
        2'b01: begin // State B
          // B loops to B on both x=0 and x=1
          state_A <= 1'b0;
          state_B <= 1'b1;
        end
        default: begin // Safety: reset state
          state_A <= 1'b1;
          state_B <= 1'b0;
        end
      endcase
    end
  end

  // Output logic (Mealy)
  always @(*) begin
    case ({state_A, state_B})
      2'b10: z = x ? 1'b1 : 1'b0;     // A: z=0 if x=0; z=1 if x=1
      2'b01: z = x ? 1'b0 : 1'b1;     // B: z=1 if x=0; z=0 if x=1
      default: z = 1'b0;
    endcase
  end

endmodule