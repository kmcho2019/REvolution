module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [1:0] state;
reg [3:0] seq_detector;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 2'b00;
    seq_detector <= 4'b0;
    start_shifting <= 0;
  end
  else begin
    case (state)
      2'b00: begin // State 0
        if (data) begin
          state <= 2'b01;
          seq_detector <= {seq_detector[2:0], 1'b1}; // Shift in the new data
        end
        else begin
          state <= 2'b00;
          seq_detector <= {seq_detector[2:0], 1'b0}; // Shift in the new data
        end
      end
      2'b01: begin // State 1
        if (data) begin
          state <= 2'b10;
          seq_detector <= {seq_detector[2:0], 1'b1}; // Shift in the new data
        end
        else begin
          state <= 2'b00;
          seq_detector <= {seq_detector[2:0], 1'b0}; // Shift in the new data
        end
      end
      2'b10: begin // State 2
        if (~data) begin
          state <= 2'b00;
          seq_detector <= {seq_detector[2:0], 1'b0}; // Shift in the new data
        end
        else begin
          state <= 2'b11;
          seq_detector <= {seq_detector[2:0], 1'b1}; // Shift in the new data
        end
      end
      2'b11: begin // State 3
        if (data) begin
          seq_detector <= {seq_detector[2:0], 1'b1}; // Shift in the new data
          if (seq_detector == 4'b1101) begin
            start_shifting <= 1; // Set shifting flag
          end
          state <= 2'b00;
        end
        else begin
          state <= 2'b00;
          seq_detector <= {seq_detector[2:0], 1'b0}; // Shift in the new data
        end
      end
    endcase
  end
end

endmodule