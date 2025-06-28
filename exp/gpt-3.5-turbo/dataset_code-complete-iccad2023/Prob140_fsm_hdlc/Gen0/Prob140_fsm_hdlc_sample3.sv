module HDLC_FSM (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // Define states
  parameter IDLE = 2'b00;
  parameter F1_FOUND = 2'b01;
  parameter F2_FOUND = 2'b10;
  parameter ERROR = 2'b11;

  // Internal signals
  reg [1:0] state, next_state;

  // Output signals
  assign disc = (state == F1_FOUND);
  assign flag = (state == F2_FOUND);
  assign err = (state == ERROR);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  always @* begin
    case (state)
      IDLE: begin
        if (in == 1)
          next_state = F1_FOUND;
        else
          next_state = IDLE;
      end
      F1_FOUND: begin
        if (in == 1)
          next_state = F2_FOUND;
        else if (in == 0)
          next_state = IDLE;
        else
          next_state = ERROR;
      end
      F2_FOUND: begin
        if (in == 1)
          next_state = ERROR;
        else
          next_state = IDLE;
      end
      ERROR: begin
        next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end

endmodule