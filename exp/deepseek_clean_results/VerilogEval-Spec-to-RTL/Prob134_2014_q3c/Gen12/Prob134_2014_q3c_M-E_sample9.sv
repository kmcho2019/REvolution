module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Packed lookup table for {next_state, z}
    // Format: {Y[2:0], z} (4 bits total)
    reg [3:0] state_table [0:15];  // 16 possible combinations of {x,y[2:0]}

    // Initialize state table according to specification
    initial begin
        // x=0 cases
        state_table[4'b0_000] = 4'b000_0;  // y=000, x=0 → next=000, z=0
        state_table[4'b0_001] = 4'b001_0;  // y=001, x=0 → next=001, z=0
        state_table[4'b0_010] = 4'b010_0;  // y=010, x=0 → next=010, z=0
        state_table[4'b0_011] = 4'b001_1;  // y=011, x=0 → next=001, z=1
        state_table[4'b0_100] = 4'b011_1;  // y=100, x=0 → next=011, z=1
        
        // x=1 cases
        state_table[4'b1_000] = 4'b001_0;  // y=000, x=1 → next=001, z=0
        state_table[4'b1_001] = 4'b100_0;  // y=001, x=1 → next=100, z=0
        state_table[4'b1_010] = 4'b001_0;  // y=010, x=1 → next=001, z=0
        state_table[4'b1_011] = 4'b010_1;  // y=011, x=1 → next=010, z=1
        state_table[4'b1_100] = 4'b100_1;  // y=100, x=1 → next=100, z=1
        
        // Default cases (shouldn't occur in normal operation)
        state_table[4'b0_101] = 4'b000_0;
        state_table[4'b0_110] = 4'b000_0;
        state_table[4'b0_111] = 4'b000_0;
        state_table[4'b1_101] = 4'b000_0;
        state_table[4'b1_110] = 4'b000_0;
        state_table[4'b1_111] = 4'b000_0;
    end

    // Lookup next state and output
    wire [3:0] next_info = state_table[{x, y}];
    assign Y0 = next_info[0];  // Y0 is bit 0 of next state
    assign z = next_info[3];   // z is the MSB of the packed info

endmodule