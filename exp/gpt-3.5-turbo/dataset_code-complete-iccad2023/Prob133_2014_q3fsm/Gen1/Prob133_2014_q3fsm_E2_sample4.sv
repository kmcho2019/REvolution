module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

// Define FSM states
parameter State_A = 2'b00;
parameter State_B = 2'b01;

// Define state register
reg [1:0] state;

// Define counter for w = 1 occurrences in State_B
reg [1:0] w_count;
reg w_prev;

// State and output logic
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= State_A;
    z <= 0;
    w_count <= 0;
    w_prev <= 0;
  end else begin
    case(state)
      State_A: begin
        if (s == 1)
          state <= State_B;
      end
      State_B: begin
        if (w == 1 && w_prev == 0) begin
          w_count <= w_count + 1;
        end
        if (w_count == 2)
          z <= 1;
        else
          z <= 0;
        
        if (state == State_B) begin
          w_prev <= w;
        end
        if (w_count == 3) begin
          w_count <= 0;
          state <= State_A;
        end
      end
    endcase
  end
end

endmodule