module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [3:0] state;
reg shift_detected;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 4'b0; // Reset state machine
    start_shifting <= 0;
  end
  else begin
    case (state)
      4'b0000: begin // State 0: Waiting for 1
        if (data) begin
          state <= 4'b0001;
        end
      end
      4'b0001: begin // State 1: 1 Detected, Waiting for 1
        if (data) begin
          state <= 4'b0010;
        end
        else begin
          state <= 4'b0000;
        end
      end
      4'b0010: begin // State 2: 11 Detected, Waiting for 0
        if (~data) begin
          state <= 4'b0011;
        end
        else begin
          state <= 4'b0000;
        end
      end
      4'b0011: begin // State 3: 110 Detected, Waiting for 1
        if (data) begin
          state <= 4'b0100;
        end
        else begin
          state <= 4'b0000;
        end
      end
      4'b0100: begin // State 4: 1101 Detected, Set start_shifting
        start_shifting <= 1;
        state <= 4'b0100; // Stay in this state
        
        // If a reset signal received, reset state machine
        if (reset) begin
          state <= 4'b0000;
          start_shifting <= 0;
        end
      end
    endcase
  end
end

endmodule