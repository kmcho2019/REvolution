module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// Define states for the sequence search
parameter IDLE = 2'b00;
parameter SEARCH_1 = 2'b01;
parameter SEARCH_2 = 2'b10;
parameter FOUND = 2'b11;

// State register and next state logic
reg [1:0] state, next_state;
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    start_shifting <= 0;
  end
  else begin
    state <= next_state;
  end
end

// State transition logic
always @(*) begin
  next_state = state;
  start_shifting = 0;
  case(state)
    IDLE: begin
      if ((data == 1'b1) && ($past(data) == 1'b1))
        next_state = SEARCH_1;
    end
    SEARCH_1: begin
      if ((data == 1'b1) && ($past(data) == 1'b0))
        next_state = SEARCH_2;
      else if (data == 1'b0)
        next_state = IDLE;
    end
    SEARCH_2: begin
      if ((data == 1'b1) && ($past(data) == 1'b1))
        next_state = FOUND;
      else if (data == 1'b0)
        next_state = IDLE;
    end
    FOUND: begin
      start_shifting = 1;
      next_state = FOUND;
    end
  endcase
end

endmodule