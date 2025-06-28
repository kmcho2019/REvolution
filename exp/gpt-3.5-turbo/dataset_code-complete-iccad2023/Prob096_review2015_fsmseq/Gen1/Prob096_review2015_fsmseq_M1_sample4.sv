module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [4:0] state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 5'b0;
    start_shifting <= 0;
  end
  else begin
    case (state)
      5'b0000: begin // State 0
        if (data) state <= 5'b0001;
        else state <= 5'b0000;
      end
      5'b0001: begin // State 1
        if (data) state <= 5'b0010;
        else state <= 5'b0000;
      end
      5'b0010: begin // State 2
        if (~data) state <= 5'b0000;
        else state <= 5'b0011;
      end
      5'b0011: begin // State 3
        if (data) state <= 5'b0100;
        else state <= 5'b0000;
      end
      5'b0100: begin // State 4
        if (data) begin
          start_shifting <= 1; // Set shifting flag only when correct sequence is found
          state <= 5'b0000;
        end
        else state <= 5'b0011;
      end
    endcase
  end
end

endmodule