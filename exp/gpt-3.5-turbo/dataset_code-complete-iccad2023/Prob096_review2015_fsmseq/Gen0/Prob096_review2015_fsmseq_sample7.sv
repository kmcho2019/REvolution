module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// Define states
parameter S0 = 2'b00; // Initial state
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

// State register and next state logic
reg [1:0] state, next_state;
always @ (posedge clk, posedge reset)
begin
  if (reset)
    state <= S0;
  else
    state <= next_state;
end

// State transition and output logic
always @ (*)
begin
  case(state)
    S0: begin
      if (data)
        next_state = S1;
      else
        next_state = S0;
    end
    S1: begin
      if (data)
        next_state = S1;
      else
        next_state = S2;
    end
    S2: begin
      if (data)
        next_state = S1;
      else
        next_state = S0;
    end
    S3: begin
      next_state = S3;
    end
  endcase

  if (state == S2 && !data)
    start_shifting = 0;
  else if (state == S3)
    start_shifting = 1;
end

endmodule