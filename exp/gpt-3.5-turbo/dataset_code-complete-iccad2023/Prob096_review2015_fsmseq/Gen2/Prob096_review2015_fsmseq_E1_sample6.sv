module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// Define states
parameter STATE_IDLE = 3'b000;
parameter STATE_1 = 3'b001;
parameter STATE_11 = 3'b010;
parameter STATE_110 = 3'b011;

reg [2:0] state, next_state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= STATE_IDLE;
    start_shifting <= 0;
  end
  else begin
    state <= next_state;
  end
end

always @* begin
  next_state = state;
  start_shifting = 0;
  
  case ({state, data})
    STATE_IDLE: begin
      if (data)
        next_state = STATE_1;
    end
    STATE_1: begin
      if (data)
        next_state = STATE_11;
      else
        next_state = STATE_IDLE;
    end
    STATE_11: begin
      if (data)
        next_state = STATE_110;
      else
        next_state = STATE_IDLE;
    end
    STATE_110: begin
      if (data)
        start_shifting = 1;
      next_state = STATE_IDLE;
    end
  endcase
end

endmodule