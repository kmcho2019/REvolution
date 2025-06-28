module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// Define states
parameter STATE_IDLE = 2'b00;
parameter STATE_1 = 2'b01;
parameter STATE_11 = 2'b10;
parameter STATE_110 = 2'b11;

reg [1:0] state, next_state;
reg [3:0] shift_register;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= STATE_IDLE;
    start_shifting <= 0;
    shift_register <= 4'b0;
  end
  else begin
    state <= next_state;
    shift_register <= {shift_register[2:0], data};
  end
end

always @* begin
  next_state = state;
  start_shifting = (state == STATE_110 && shift_register == 4'b1101) ? 1 : 0;
  
  case (state)
    STATE_IDLE: begin
      if (data) begin
        next_state = STATE_1;
      end
    end
    STATE_1: begin
      if (data) begin
        next_state = STATE_11;
      end else begin
        next_state = STATE_IDLE;
      end
    end
    STATE_11: begin
      if (data) begin
        next_state = STATE_110;
      end else begin
        next_state = STATE_IDLE;
      end
    end
    STATE_110: begin
      if (!data) begin
        next_state = STATE_IDLE;
      end
    end
  endcase
end

endmodule