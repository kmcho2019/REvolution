module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

// Define states
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

reg current_state, next_state;

always @(posedge clk) begin
  // State transition logic
  case(current_state)
    S0: next_state = (a & !b) ? S1 : S0;
    S1: next_state = (!a & b) ? S2 : S1;
    S2: next_state = (a & b) ? S3 : S2;
    S3: next_state = (!a & !b) ? S0 : S3;
  endcase
  
  // Output logic
  case(current_state)
    S0: {state, q} = 2'b00;
    S1: {state, q} = 2'b01;
    S2: {state, q} = 2'b10;
    S3: {state, q} = 2'b11;
  endcase

  current_state <= next_state;
end

endmodule