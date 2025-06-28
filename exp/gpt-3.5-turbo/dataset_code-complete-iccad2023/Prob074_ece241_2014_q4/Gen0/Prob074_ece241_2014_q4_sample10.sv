module TopModule (
  input clk,
  input x,
  output reg z
);

// Define states
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
reg [1:0] state, next_state;

// D flip-flops for state storage
always @(posedge clk)
begin
  state <= next_state;
end

// Combinational logic for state transitions
always @(*)
begin
  case(state)
    S0: begin
      if(x) next_state = S1;
      else next_state = S0;
    end
    S1: begin
      if(x) next_state = S2;
      else next_state = S0;
    end
    S2: begin
      if(x) next_state = S2;
      else next_state = S1;
    end
    default: next_state = S0;
  endcase
end

// Output generation based on state
always @(*)
begin
  case(state)
    S0: z = ~(state[0] ^ x);
    S1: z = ~(state[0] & ~x);
    S2: z = ~(state[0] | ~x);
    default: z = 1'b0;
  endcase
end

endmodule