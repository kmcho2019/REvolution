module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// State definition
parameter IDLE = 2'b00;
parameter S_1 = 2'b01;
parameter S_11 = 2'b10;
parameter S_110 = 2'b11;

reg [1:0] state; // Current state shift register

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    start_shifting <= 1'b0;
  end else begin
    case(state)
      IDLE: begin
        if (data) begin
          state <= S_1;
        end
      end
      S_1: begin
        if (data) begin
          state <= S_11;
        end else begin
          state <= IDLE;
        end
      end
      S_11: begin
        if (data) begin
          state <= S_110;
        end else begin
          state <= IDLE;
        end
      end
      S_110: begin
        if (data) begin
          start_shifting <= 1'b1; // Sequence found, set start_shifting
          state <= IDLE; // Return to IDLE state
        end else begin
          state <= IDLE;
        end
      end
    endcase
  end
end

endmodule