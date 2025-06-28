module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [3:0] state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 4'b0;
    start_shifting <= 0;
  end
  else begin
    case (state)
      4'b0: begin
        if (data) state <= 4'b1;
      end
      4'b1: begin
        if (data) state <= 4'b10;
        else state <= 4'b0;
      end
      4'b10: begin
        if (~data) state <= 4'b0;
        else state <= 4'b11;
      end
      4'b11: begin
        if (data) begin
          state <= 4'b0;
          start_shifting <= 1;
        end
        else state <= 4'b0;
      end
    endcase
  end
end

endmodule