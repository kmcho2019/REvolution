module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [2:0] state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 3'b0;
    start_shifting <= 0;
  end
  else begin
    case (state)
      3'b000: begin // State 0
        if (data) state <= 3'b001;
        else state <= 3'b000;
      end
      3'b001: begin // State 1
        if (data) state <= 3'b010;
        else state <= 3'b000;
      end
      3'b010: begin // State 2
        if (~data) state <= 3'b000;
        else state <= 3'b011;
      end
      3'b011: begin // State 3
        if (data) begin
          start_shifting <= 1; // Signal sequence found
        end
        state <= 3'b011;
      end
    endcase
  end
end

endmodule