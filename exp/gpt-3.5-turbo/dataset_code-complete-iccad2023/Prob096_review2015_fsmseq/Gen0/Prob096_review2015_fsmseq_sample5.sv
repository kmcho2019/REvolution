module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// State definition
parameter IDLE = 2'b00;
parameter STATE1 = 2'b01;
parameter STATE2 = 2'b10;
parameter STATE3 = 2'b11;

// State and next state registers
reg [1:0] state, next_state;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    start_shifting <= 0;
  end
  else begin
    state <= next_state;
    start_shifting <= (state == STATE3);
  end
end

always @* begin
  next_state = state;
  case (state)
    IDLE: begin
      if (data) next_state = STATE1;
    end
    STATE1: begin
      if (data) next_state = STATE2;
      else next_state = IDLE;
    end
    STATE2: begin
      if (!data) next_state = STATE3;
      else next_state = IDLE;
    end
    STATE3: begin
      if (data) next_state = STATE1;
      else next_state = IDLE;
    end
  endcase
end

endmodule