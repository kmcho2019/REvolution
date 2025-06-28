module HDLC_FSM (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  reg [1:0] state, next_state;

  always @ (posedge clk) begin
    if (reset) begin
      state <= 2'b00; // IDLE state
    end else begin
      state <= next_state;
    end
  end

  always @* begin
    case(state)
      2'b00: begin // IDLE
        if (in == 1'b0)
          next_state = 2'b01; // Move to state ONE
        else
          next_state = 2'b00; // Remain in IDLE state
      end
      2'b01: begin // ONE
        if (in == 1'b1)
          next_state = 2'b10; // Move to state MORE_ONES
        else
          next_state = 2'b01; // Remain in ONE state
      end
      2'b10: begin // MORE_ONES
        if (in == 1'b0) begin
          next_state = 2'b00; // Move back to IDLE
          disc = 1'b1; // Signal a bit needs to be discarded
        end
        else if ((in == 1'b1) && (flag == 1'b0))
          next_state = 2'b11; // Potential flag or error
        else
          next_state = 2'b10; // Remain in MORE_ONES state
      end
      2'b11: begin // FLAG or ERR
        if (in == 1'b1) begin
          err = 1'b1; // Signal error
          flag = 1'b0; // Reset flag
        end
        else begin
          flag = 1'b1; // Signal frame flag
          err = 1'b0; // Reset error
        end
        next_state = 2'b00; // Move back to IDLE
      end
      default: next_state = 2'b00; // Default to IDLE
    endcase
  end

endmodule