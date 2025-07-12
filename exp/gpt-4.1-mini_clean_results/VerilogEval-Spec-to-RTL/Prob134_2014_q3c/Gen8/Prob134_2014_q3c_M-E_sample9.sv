module TopModule (
    input        clk,   // clock input (not used)
    input        x,
    input  [2:0] y,     // present state
    output       Y0,
    output       z
);

    // Declare a lookup table with 5 valid states * 2 inputs = 10 entries
    // Each entry encodes {z, next_state[2:0]} as 4 bits
    // Index = {y[2:0], x}
    // Invalid states default to 0
    reg [3:0] fsm_table [0:15];

    initial begin
        // Initialize all entries to default {z=0, next_state=3'b000}
        integer i;
        for (i = 0; i < 16; i = i + 1)
            fsm_table[i] = 4'b0000;

        // Explicit valid entries from the FSM specification:
        // y=000 (0), x=0: next=000, z=0 => 4'b0_000
        fsm_table[{3'b000,1'b0}] = 4'b0_000;
        // y=000 (0), x=1: next=001, z=0 => 4'b0_001
        fsm_table[{3'b000,1'b1}] = 4'b0_001;

        // y=001 (1), x=0: next=001, z=0
        fsm_table[{3'b001,1'b0}] = 4'b0_001;
        // y=001 (1), x=1: next=100, z=0
        fsm_table[{3'b001,1'b1}] = 4'b0_100;

        // y=010 (2), x=0: next=010, z=0
        fsm_table[{3'b010,1'b0}] = 4'b0_010;
        // y=010 (2), x=1: next=001, z=0
        fsm_table[{3'b010,1'b1}] = 4'b0_001;

        // y=011 (3), x=0: next=001, z=1
        fsm_table[{3'b011,1'b0}] = 4'b1_001;
        // y=011 (3), x=1: next=010, z=1
        fsm_table[{3'b011,1'b1}] = 4'b1_010;

        // y=100 (4), x=0: next=011, z=1
        fsm_table[{3'b100,1'b0}] = 4'b1_011;
        // y=100 (4), x=1: next=100, z=1
        fsm_table[{3'b100,1'b1}] = 4'b1_100;
    end

    wire [3:0] combined;
    assign combined = fsm_table[{y, x}];

    // combined[3] = z output
    // combined[2:0] = next state
    assign z = combined[3];
    assign Y0 = combined[0];

endmodule