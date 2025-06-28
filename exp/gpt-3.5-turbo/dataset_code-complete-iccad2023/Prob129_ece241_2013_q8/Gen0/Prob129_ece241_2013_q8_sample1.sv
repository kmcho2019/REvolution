module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  reg [1:0] state;

  always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
      state <= 2'b00; // Initialize state to S0 on reset
      z <= 1'b0;
    end
    else begin
      case (state)
        2'b00: begin // State S0
          if (x) begin
            state <= 2'b01; // Transition to State S1
          end
          else begin
            state <= 2'b00; // Stay in State S0
          end
        end
        2'b01: begin // State S1
          if (x) begin
            state <= 2'b10; // Transition to State S2
          end
          else begin
            state <= 2'b00; // Go back to State S0
          end
        end
        2'b10: begin // State S2
          if (x) begin
            state <= 2'b10; // Stay in State S2
            z <= 1'b1; // Sequence "101" detected
          end
          else begin
            state <= 2'b00; // Go back to State S0
          end
        end
      endcase
    end
  end

endmodule