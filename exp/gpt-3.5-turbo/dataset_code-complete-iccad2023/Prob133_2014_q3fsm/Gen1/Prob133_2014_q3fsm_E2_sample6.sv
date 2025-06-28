module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

// Define the states
typedef enum logic [1:0] {
  State_A,
  State_B,
  Transient_state
} state_t;

// Define the state variable
reg [1:0] state, next_state;

// Define the counter for w
reg [1:0] w_count;

always @(posedge clk) begin
  if (reset) begin
    state <= State_A;
    z <= 0;
    w_count <= 0;
  end else begin
    state <= next_state;
  end
end

always @* begin
  next_state = state;
  case(state)
    State_A: begin
      if (s == 1) begin
        next_state = State_B;
        w_count <= 0;
      end
    end
    State_B: begin
      if (w == 1) begin
        w_count <= w_count + 1;
      end
      if (w_count == 2) begin
        next_state = Transient_state;
        z <= 1;
      end else begin
        next_state = State_B; // Stay in State_B to check w for the next 3 cycles
        z <= 0;
      end
    end
    Transient_state: begin
      next_state = State_A;
    end
  endcase
end

endmodule