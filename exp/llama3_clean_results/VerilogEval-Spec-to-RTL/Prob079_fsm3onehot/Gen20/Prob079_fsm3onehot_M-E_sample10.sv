module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // Simplified state transition logic
    logic [3:0] next_state_A, next_state_B, next_state_C, next_state_D;

    assign next_state_A = in ? B : A;
    assign next_state_B = in ? B : C;
    assign next_state_C = in ? D : A;
    assign next_state_D = in ? B : C;

    assign next_state = (state == A) ? next_state_A :
                        (state == B) ? next_state_B :
                        (state == C) ? next_state_C :
                        (state == D) ? next_state_D : 4'bxxxx;

    // Output logic
    assign out = state[3]; // Output is high only in state D

endmodule