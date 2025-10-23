module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Pre-compute next states for all possible current states
wire [1:0] next_A = in ? 2'b01 : 2'b00;
wire [1:0] next_B = in ? 2'b01 : 2'b10;
wire [1:0] next_C = in ? 2'b11 : 2'b00;
wire [1:0] next_D = in ? 2'b01 : 2'b10;

// Select next state based on current state
assign next_state = (state == 2'b00) ? next_A :
                   (state == 2'b01) ? next_B :
                   (state == 2'b10) ? next_C :
                   next_D;

// Output is 1 only in state D
assign out = (state == 2'b11);

endmodule