module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// State encoding parameters
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// State transition logic using continuous assignments
assign next_state[0] = (state == A & in) |         // A->B when in=1
                       (state == B) |              // B stays when in=1 or goes to C when in=0
                       (state == C & in) |         // C->D when in=1
                       (state == D & ~in);         // D->C when in=0

assign next_state[1] = (state == B & ~in) |        // B->C when in=0
                       (state == C) |              // C->A when in=0 or D when in=1
                       (state == D & ~in);         // D->C when in=0

// Output logic - only high in state D
assign out = (state == D);

endmodule