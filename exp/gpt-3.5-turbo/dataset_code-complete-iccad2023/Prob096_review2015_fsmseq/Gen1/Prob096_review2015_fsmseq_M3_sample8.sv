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
    case(state)
      2'b00: begin // State 0
        if (data) state <= 2'b01;
      end
      2'b01: begin // State 1
        if (data) state <= 2'b10;
        else state <= 2'b00;
      end
      2'b10: begin // State 2
        if (~data) state <= 2'b00;
        else state <= 2'b11;
      end
      2'b11: begin // State 3
        if (data) begin
          start_shifting <= 1;
          state <= 2'b00;
        end
        else state <= 2'b00;
      end
    endcase
  end
end

endmodule