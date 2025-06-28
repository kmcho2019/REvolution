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
      4'b0000: begin // State 0
        if (data) state <= 4'b0001;
        else state <= 4'b0000;
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
        if (~data) state <= 4'b0000;
        else begin
          start_shifting <= 0; // Reset start_shifting
          state <= 4'b0100;
        end
      end
      4'b0100: begin // State 4
        if (data) begin // Sequence 1101 detected
          start_shifting <= 1; // Set shifting flag
          state <= 4'b0001; // Move back to State 1 to continue searching
        end
        else state <= 4'b0000;
      end
    endcase
  end
end

endmodule