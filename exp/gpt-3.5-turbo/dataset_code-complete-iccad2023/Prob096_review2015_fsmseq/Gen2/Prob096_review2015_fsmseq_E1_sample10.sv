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

reg [1:0] state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= STATE_IDLE;
    start_shifting <= 0;
  end
  else begin
    case (state)
      STATE_IDLE: begin
        if (data) begin
          state <= STATE_1;
          start_shifting <= 0;
        end
      end
      STATE_1: begin
        if (data) begin
          state <= STATE_11;
          start_shifting <= 0;
        end
        else begin
          state <= STATE_IDLE;
          start_shifting <= 0;
        end
      end
      STATE_11: begin
        if (data) begin
          state <= STATE_110;
          start_shifting <= 0;
        end
        else begin
          state <= STATE_IDLE;
          start_shifting <= 0;
        end
      end
      STATE_110: begin
        if (data) begin
          state <= STATE_110;
          start_shifting <= 1;
        end
        else begin
          state <= STATE_IDLE;
          start_shifting <= 0;
        end
      end
    endcase
  end
end

endmodule