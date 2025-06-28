module TimerStateMachine (
  input data,
  input done_counting,
  input ack,
  output reg shift_ena,
  output reg counting,
  output reg done
);

  reg [2:0] state;

  always @(*) begin
    case (state)
      3'b000: begin  // IDLE state
        if (data == 3'b110) begin
          state <= 3'b001; // Move to PATTERN_DETECT state
        end
      end
      3'b001: begin  // PATTERN_DETECT state
        if (data == 3'b1101) begin
          state <= 3'b010; // Move to SHIFT_ENA state
        end else begin
          state <= 3'b000; // Revert to IDLE state
        end
      end
      3'b010: begin  // SHIFT_ENA state
        state <= done_counting ? 3'b011 : 3'b010; // Move to COUNTING if done_counting is high
      end
      3'b011: begin  // COUNTING state
        state <= done_counting ? 3'b100 : 3'b011; // Continue COUNTING until done_counting is low
      end
      3'b100: begin  // DONE_WAIT state
        state <= ack ? 3'b101 : 3'b100; // Move to DONE_ACK_WAIT if ack is high
      end
      3'b101: begin  // DONE_ACK_WAIT state
        state <= ~ack ? 3'b000 : 3'b101; // Go back to IDLE once ack is low
      end
    endcase
  end

  always @(*) begin
    case (state)
      3'b010: begin  // SHIFT_ENA state
        shift_ena = 1;
        counting = 0;
        done = 0;
      end
      3'b011: begin  // COUNTING state
        shift_ena = 0;
        counting = 1;
        done = 0;
      end
      3'b100: begin  // DONE_WAIT state
        shift_ena = 0;
        counting = 0;
        done = 1;
      end
      default: begin
        shift_ena = 0;
        counting = 0;
        done = 0;
      end
    endcase
  end

endmodule