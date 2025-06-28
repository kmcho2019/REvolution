module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// State definition
parameter S_IDLE = 2'b00;
parameter S_1 = 2'b01;
parameter S_11 = 2'b10;
parameter S_110 = 2'b11;

reg [1:0] state; // Current state
reg [3:0] shift_count; // Counter to keep track of sequence found

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= S_IDLE;
    shift_count <= 4'b0;
    start_shifting <= 1'b0;
  end else begin
    case(state)
      S_IDLE: begin
        if (data) begin
          state <= S_1;
          shift_count <= 4'b1;
        end
      end
      S_1: begin
        if (data) begin
          state <= S_11;
          shift_count <= 4'b10;
        end else begin
          state <= S_IDLE;
          shift_count <= 4'b0;
        end
      end
      S_11: begin
        if (data) begin
          state <= S_110;
          shift_count <= 4'b11;
        end else begin
          state <= S_IDLE;
          shift_count <= 4'b0;
        end
      end
      S_110: begin
        if (data) begin
          start_shifting <= 1'b1; // Sequence found, set start_shifting
          // Remain in this state until reset
        end else begin
          state <= S_IDLE;
          shift_count <= 4'b0;
        end
      end
    endcase
  end
end

endmodule