module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Declare a 2D reg array: 5 states x 2 inputs
    // Each entry holds {z, Y_next[2:0]} packed into 4 bits: {z, Y2, Y1, Y0}
    reg [3:0] fsm_table [0:4][0:1];

    initial begin
        // Initialize the FSM table for valid states and inputs
        // Format: {z, Y2, Y1, Y0}
        // State 000
        fsm_table[0][0] = 4'b0000; // x=0: next=000, z=0
        fsm_table[0][1] = 4'b0001; // x=1: next=001, z=0
        // State 001
        fsm_table[1][0] = 4'b0001; // next=001, z=0
        fsm_table[1][1] = 4'b1100; // next=100, z=0 but z=0, here we encode as 1'b0 at MSB. So correct to 0
                                  // careful: problem says z=0 for this state (001), so actually 0
        // Correction: For 001, z=0, so both 0
        fsm_table[1][0] = 4'b0001; // next=001, z=0
        fsm_table[1][1] = 4'b0100; // next=100, z=0, pack as 0_100 = 4'b0100

        // State 010
        fsm_table[2][0] = 4'b0010; // next=010, z=0
        fsm_table[2][1] = 4'b0001; // next=001, z=0
        // State 011
        fsm_table[3][0] = 4'b1001; // next=001, z=1
        fsm_table[3][1] = 4'b1010; // next=010, z=1
        // State 100
        fsm_table[4][0] = 4'b1011; // next=011, z=1
        fsm_table[4][1] = 4'b1100; // next=100, z=1
    end

    wire [3:0] out;
    // Map input state y to 0..4 index if valid, else 0 by default
    wire [2:0] y_idx = (y <= 3'b100) ? y : 3'b000;

    assign out = fsm_table[y_idx][x];

    assign z  = out[3];
    assign Y0 = out[0];

endmodule