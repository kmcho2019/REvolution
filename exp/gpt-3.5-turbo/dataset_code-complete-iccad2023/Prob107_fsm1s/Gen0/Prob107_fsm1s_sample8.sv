module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

// Define the states
parameter B = 0;
parameter A = 1;

// Define the state register
reg [1:0] state, next_state;

// Moore state machine logic
always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= B;
  end else begin
    state <= next_state;
  end
end

// Define the next state and output logic
always @ (*) begin
  case (state)
    B: begin
      if (in) begin
        next_state = B;
      end else begin
        next_state = A;
      end
      out = 1;
    end
    A: begin
      if (in) begin
        next_state = A;
      end else begin
        next_state = B;
      end
      out = 0;
    end
  endcase
end

endmodule