module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// Define states
parameter IDLE = 2'b00;
parameter STATE_1 = 2'b01;
parameter STATE_2 = 2'b10;
parameter FOUND = 2'b11;

// State and next state registers
reg [1:0] state, next_state;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

// State transition and output logic
always @* begin
  case (state)
    IDLE: begin
      if (data)
        next_state = STATE_1;
      else
        next_state = IDLE;
    end
    STATE_1: begin
      if (data)
        next_state = STATE_2;
      else
        next_state = IDLE;
    end
    STATE_2: begin
      if (data)
        next_state = FOUND;
      else
        next_state = IDLE;
    end
    FOUND: begin
      next_state = FOUND;
    end
  endcase
end

// Output generation
always @* begin
  if (state == FOUND)
    start_shifting = 1;
  else
    start_shifting = 0;
end

endmodule