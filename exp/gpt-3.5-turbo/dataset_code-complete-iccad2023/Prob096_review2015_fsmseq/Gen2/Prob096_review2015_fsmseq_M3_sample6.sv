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
  
  start_shifting = (state == STATE_110 && data) ? 1 :
                   (state == STATE_IDLE && data) ? STATE_1 :
                   (state == STATE_1 && data) ? STATE_11 :
                   (state == STATE_11 && data) ? STATE_110 :
                   state == STATE_110 ? 1'b1 : 1'b0;
  
end

endmodule