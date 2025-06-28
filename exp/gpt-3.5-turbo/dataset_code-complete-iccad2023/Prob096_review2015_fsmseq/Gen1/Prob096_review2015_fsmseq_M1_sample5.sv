module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// State definition
parameter S_IDLE = 3'b000;
parameter S_1 = 3'b001;
parameter S_11 = 3'b010;
parameter S_110 = 3'b011;
parameter S_1101 = 3'b100;

reg [2:0] state; // Current state

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= S_IDLE;
    start_shifting <= 1'b0;
  end else begin
    case(state)
      S_IDLE: begin
        if (data) begin
          state <= S_1;
        end
      end
      S_1: begin
        if (data) begin
          state <= S_11;
        end else begin
          state <= S_IDLE;
        end
      end
      S_11: begin
        if (data) begin
          state <= S_110;
        end else begin
          state <= S_IDLE;
        end
      end
      S_110: begin
        if (data) begin
          state <= S_1101;
        end else begin
          state <= S_IDLE;
        end
      end
      S_1101: begin
        start_shifting <= 1'b1; // Sequence found, set start_shifting
        state <= S_1101; // Remain in this state until reset
      end
    endcase
  end
end

endmodule