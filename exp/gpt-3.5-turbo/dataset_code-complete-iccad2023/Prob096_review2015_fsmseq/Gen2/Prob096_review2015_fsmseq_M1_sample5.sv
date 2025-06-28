module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [3:0] state;
reg start_sequence; // Flag to indicate when the sequence begins

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 4'b0000;
    start_sequence <= 0;
    start_shifting <= 0;
  end
  else begin
    case (state)
      4'b0000: begin // State 0
        if (data) begin
          state <= 4'b0001;
          start_sequence <= 1;
        end
        else state <= 4'b0000;
      end
      4'b0001: begin // State 1
        if (data) state <= 4'b0010;
        else begin
          state <= 4'b0000;
          start_sequence <= 0;
        end
      end
      4'b0010: begin // State 2
        if (data) state <= 4'b0011;
        else begin
          state <= 4'b0000;
          start_sequence <= 0;
        end
      end
      4'b0011: begin // State 3
        if (data) begin
          state <= 4'b0000;
          start_sequence <= 0;
          start_shifting <= 1; // Set shifting flag
        end
        else begin
          state <= 4'b0000;
          start_sequence <= 0;
        end
      end
    endcase
  end
end

endmodule