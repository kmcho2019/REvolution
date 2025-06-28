module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

  // Define states
  parameter OFF = 1'b0;
  parameter ON = 1'b1;

  // State register
  reg state, next_state;

  // Synchronous state and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= OFF;
      out <= 1'b0;
    end else begin
      state <= next_state;
      case (state)
        OFF: begin
          if (j)
            next_state = ON;
          else
            next_state = OFF;
        end
        ON: begin
          if (k)
            next_state = OFF;
          else
            next_state = ON;
        end
      endcase
    end
  end

  // Output logic
  always @* begin
    case (state)
      OFF: out = 1'b0;
      ON: out = 1'b1;
    endcase
  end

endmodule