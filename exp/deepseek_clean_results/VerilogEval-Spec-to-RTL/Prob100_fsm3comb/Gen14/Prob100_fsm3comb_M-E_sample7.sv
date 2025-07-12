module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Pre-compute all possible next states
wire [1:0] next_A = in ? 2'b01 : 2'b00;  // A->B or A->A
wire [1:0] next_B = in ? 2'b01 : 2'b10;  // B->B or B->C
wire [1:0] next_C = in ? 2'b11 : 2'b00;  // C->D or C->A
wire [1:0] next_D = in ? 2'b01 : 2'b10;  // D->B or D->C

// Select next state based on current state
assign next_state = (state == 2'b00) ? next_A :
                    (state == 2'b01) ? next_B :
                    (state == 2'b10) ? next_C :
                    next_D;

// Output is high only in state D (11)
assign out = &state;  // AND of both state bits (true only when both are 1)

endmodule