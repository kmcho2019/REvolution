module HDLC_FSM (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // State encoding: IDLE = 2'b00, SEEN_1 = 2'b01, SEEN_2 = 2'b10, ERR = 2'b11
  reg [1:0] state, next_state;
  reg [2:0] ones_count;
  wire is_6_ones = (ones_count == 3'd6);
  wire is_7_ones = (ones_count >= 3'd7);

  // Outputs
  assign disc = (state == 2'b01) && !in;
  assign flag = (state == 2'b10) && in;
  assign err = (state == 2'b11);

  // Next state and count logic
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b00;
      ones_count <= 3'd0;
    end
    else begin
      state <= next_state;
      ones_count <= (in) ? (ones_count + 1) : 3'd0;
    end
  end

  // FSM nextState logic
  always @* begin
    case(state)
      2'b00: begin
        next_state = (in) ? 2'b01 : 2'b00;
      end
      2'b01: begin
        next_state = (in) ? 2'b10 : 2'b00;
      end
      2'b10: begin
        next_state = (is_6_ones) ? 2'b00 : (is_7_ones) ? 2'b11 : 2'b10;
      end
      2'b11: begin
        next_state = (in) ? 2'b11 : 2'b00;
      end
      default: next_state = 2'b00; // Reset to IDLE state if in unknown state
    endcase
  end

endmodule