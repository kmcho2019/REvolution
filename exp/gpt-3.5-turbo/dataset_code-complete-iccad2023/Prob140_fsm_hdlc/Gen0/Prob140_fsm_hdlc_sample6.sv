module HDLC_FSM (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // Define states
  parameter STATE_IDLE = 2'b00;
  parameter STATE_DISCARD = 2'b01;
  parameter STATE_FLAG = 2'b10;
  parameter STATE_ERROR = 2'b11;

  // Registers
  reg [1:0] state, next_state;

  // Output assignments
  assign disc = (state == STATE_DISCARD);
  assign flag = (state == STATE_FLAG);
  assign err = (state == STATE_ERROR);

  // State transition logic
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      state <= STATE_IDLE;
    end
    else begin
      state <= next_state;
    end
  end

  // Next state logic
  always @* begin
    case (state)
      STATE_IDLE: begin
        if (in) begin
          next_state = STATE_DISCARD;
        end
        else begin
          next_state = STATE_IDLE;
        end
      end

      STATE_DISCARD: begin
        if (in) begin
          next_state = STATE_ERROR;
        end
        else begin
          next_state = STATE_FLAG;
        end
      end

      STATE_FLAG: begin
        if (in) begin
          next_state = STATE_ERROR;
        end
        else begin
          next_state = STATE_FLAG;
        end
      end

      STATE_ERROR: begin
        if (in) begin
          next_state = STATE_ERROR;
        end
        else begin
          next_state = STATE_IDLE;
        end
      end
    endcase
  end

endmodule