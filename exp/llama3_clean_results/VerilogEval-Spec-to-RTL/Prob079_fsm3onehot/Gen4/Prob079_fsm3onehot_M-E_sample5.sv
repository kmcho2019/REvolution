module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Define the next states and outputs for each current state and input combination
    localparam [3:0] NS_A_0 = 4'b0001; // Next state for A, in=0
    localparam [3:0] NS_A_1 = 4'b0010; // Next state for A, in=1
    localparam [3:0] NS_B_0 = 4'b0100; // Next state for B, in=0
    localparam [3:0] NS_B_1 = 4'b0010; // Next state for B, in=1
    localparam [3:0] NS_C_0 = 4'b0001; // Next state for C, in=0
    localparam [3:0] NS_C_1 = 4'b1000; // Next state for C, in=1
    localparam [3:0] NS_D_0 = 4'b0100; // Next state for D, in=0
    localparam [3:0] NS_D_1 = 4'b0010; // Next state for D, in=1

    localparam OUT_A = 1'b0; // Output for A
    localparam OUT_B = 1'b0; // Output for B
    localparam OUT_C = 1'b0; // Output for C
    localparam OUT_D = 1'b1; // Output for D

    // State transition logic using LUT approach
    assign next_state = (
        (state == 4'b0001 && in == 1'b0)? NS_A_0 :
        (state == 4'b0001 && in == 1'b1)? NS_A_1 :
        (state == 4'b0010 && in == 1'b0)? NS_B_0 :
        (state == 4'b0010 && in == 1'b1)? NS_B_1 :
        (state == 4'b0100 && in == 1'b0)? NS_C_0 :
        (state == 4'b0100 && in == 1'b1)? NS_C_1 :
        (state == 4'b1000 && in == 1'b0)? NS_D_0 :
        (state == 4'b1000 && in == 1'b1)? NS_D_1 :
        4'bxxxx
    );

    // Output logic using LUT approach
    assign out = (
        (state == 4'b0001)? OUT_A :
        (state == 4'b0010)? OUT_B :
        (state == 4'b0100)? OUT_C :
        (state == 4'b1000)? OUT_D :
        1'b0
    );

endmodule