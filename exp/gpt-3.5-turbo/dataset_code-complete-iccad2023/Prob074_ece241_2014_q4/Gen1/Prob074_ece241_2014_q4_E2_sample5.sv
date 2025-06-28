module TopModule (
  input clk,
  input x,
  output reg z
);

reg [1:0] state, next_state;
reg d_flip_flop_xor, d_flip_flop_and, d_flip_flop_or;

// D flip-flops to store the gate outputs
always @(posedge clk)
begin
  d_flip_flop_xor <= state[0] ^ x;
  d_flip_flop_and <= state[1] & ~x;
  d_flip_flop_or <= state[1] | ~x;
end

// State transition logic
always @(posedge clk)
begin
  state <= next_state;
end

always @(*)
begin
  case(state)
    2'b00: begin
      if (x) next_state = 2'b01;
      else next_state = 2'b00;
    end
    2'b01: begin
      if (x) next_state = 2'b10;
      else next_state = 2'b00;
    end
    2'b10: begin
      if (x) next_state = 2'b10;
      else next_state = 2'b01;
    end
    default: next_state = 2'b00;
  endcase
end

// Output generation using the NOR gate
assign z = ~(d_flip_flop_xor | d_flip_flop_and | d_flip_flop_or);

endmodule