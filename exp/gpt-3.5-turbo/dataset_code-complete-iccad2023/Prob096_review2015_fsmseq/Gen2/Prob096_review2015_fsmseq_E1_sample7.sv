module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [3:0] state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 4'b0000;
    start_shifting <= 0;
  end
  else begin
    case (state)
      4'b0000: begin // State 0
        if (data) state <= 4'b0001;
      end
      4'b0001: begin // State 1
        if (data) state <= 4'b0010;
        else state <= 4'b0000;
      end
      4'b0010: begin // State 2
        if (data) state <= 4'b0011;
        else state <= 4'b0000;
      end
      4'b0011: begin // State 3
        if (data) begin
          start_shifting <= 1; // Set shifting flag when sequence detected
          state <= 4'b0111; // Move to pseudo final state
        end
        else begin
          state <= 4'b0000; // Reset if sequence interrupted
        end
      end
      4'b0111: begin // Pseudo Final State
        start_shifting <= 1; // Remain in shifting state until reset
      end
    endcase
  end
end

endmodule