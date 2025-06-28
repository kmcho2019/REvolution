module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

// Define the states
parameter B = 2'b00;
parameter A = 2'b01;

reg [1:0] state, next_state;

// State transition and output logic
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= B;
    out <= 1; // Initial state output
  end
  else begin
    state <= next_state;
    case(state)
      B: begin
        if (in) begin
          next_state = B;
        end
        else begin
          next_state = A;
          out <= 0;
        end
      end
      A: begin
        if (in) begin
          next_state = A;
        end
        else begin
          next_state = B;
          out <= 1;
        end
      end
      default: next_state = B;
    endcase
  end
end

endmodule