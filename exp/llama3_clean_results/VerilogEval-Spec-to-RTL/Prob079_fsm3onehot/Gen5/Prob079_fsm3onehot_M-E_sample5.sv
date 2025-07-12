module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    wire [3:0] A = 4'b0001;
    wire [3:0] B = 4'b0010;
    wire [3:0] C = 4'b0100;
    wire [3:0] D = 4'b1000;

    // Define the LUT for state transitions
    wire [3:0] next_state_A_in0 = A;
    wire [3:0] next_state_A_in1 = B;
    wire [3:0] next_state_B_in0 = C;
    wire [3:0] next_state_B_in1 = B;
    wire [3:0] next_state_C_in0 = A;
    wire [3:0] next_state_C_in1 = D;
    wire [3:0] next_state_D_in0 = C;
    wire [3:0] next_state_D_in1 = B;

    // State transition logic using LUT
    assign next_state = (
        (state == A)? (in? next_state_A_in1 : next_state_A_in0) :
        (state == B)? (in? next_state_B_in1 : next_state_B_in0) :
        (state == C)? (in? next_state_C_in1 : next_state_C_in0) :
        (state == D)? (in? next_state_D_in1 : next_state_D_in0) :
        4'bxxxx
    );

    // Define the LUT for output values
    wire out_A = 1'b0;
    wire out_B = 1'b0;
    wire out_C = 1'b0;
    wire out_D = 1'b1;

    // Output logic using LUT
    assign out = (
        (state == A)? out_A :
        (state == B)? out_B :
        (state == C)? out_C :
        (state == D)? out_D :
        1'b0
    );

endmodule