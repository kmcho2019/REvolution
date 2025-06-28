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
reg [1:0] state, next_state;

// Define counter for w = 1 occurrences in State_B
reg [1:0] w_count;

// Define the FSM
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= State_A;
    z <= 0;
    w_count <= 0;
  end else begin
    state <= next_state;
    case(state)
      State_A: begin
        if (s == 1)
          next_state = State_B;
        else
          next_state = State_A;
        z <= 0;
      end
      State_B: begin
        if (w == 1) begin
          w_count <= w_count + 1;
        end
        if (w_count == 2)
          z <= 1;
        else
          z <= 0;
        
        // Transition back to State_A after 3 clock cycles in State_B
        case(w_count)
          2: begin
            w_count <= 0;
            next_state = State_A;
          end
          default: next_state = State_B;
        endcase
      end
    endcase
  end
end

endmodule