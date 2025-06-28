module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [1:0] state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 2'b00;
    start_shifting <= 0;
  end
  else begin
    case (state)
      2'b00: begin // STATE_IDLE
        if (data) state <= 2'b01;
        else state <= 2'b00;
      end
      2'b01: begin // STATE_1
        if (data) state <= 2'b10;
        else state <= 2'b00;
      end
      2'b10: begin // STATE_11
        if (data) state <= 2'b11;
        else state <= 2'b00;
      end
      2'b11: begin // STATE_110
        if (data) begin
          start_shifting <= 1; // Set shifting flag
        end
        else state <= 2'b00;
      end
    endcase
  end
end

endmodule