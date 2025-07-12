module TopModule (
    input clk,           // clock input (unused internally)
    input x,
    input [2:0] y,       // present state input
    output Y0,
    output reg z
);

    // Define next state table indexed by {y, x} = 4 bits
    // y ranges 0 to 4 (only valid states), x is 0 or 1
    // next_state_table[{y,x}] = next state (3 bits)
    localparam [3:0] ENTRY_NUM = 10;
    localparam [3:0] IDX_BITS = 4;

    // We'll create a 16-entry array for safety, with invalid entries zeroed.
    reg [2:0] next_state_table [0:15];
    reg       output_z_table  [0:15];

    integer i;

    initial begin
        // Initialize all entries to zero default
        for (i = 0; i < 16; i = i + 1) begin
            next_state_table[i] = 3'b000;
            output_z_table[i]  = 1'b0;
        end

        // Assign entries based on {y,x} (4 bits)
        // For x=0 (LSB=0)
        next_state_table[{3'b000,1'b0}] = 3'b000; output_z_table[{3'b000,1'b0}] = 1'b0;
        next_state_table[{3'b001,1'b0}] = 3'b001; output_z_table[{3'b001,1'b0}] = 1'b0;
        next_state_table[{3'b010,1'b0}] = 3'b010; output_z_table[{3'b010,1'b0}] = 1'b0;
        next_state_table[{3'b011,1'b0}] = 3'b001; output_z_table[{3'b011,1'b0}] = 1'b1;
        next_state_table[{3'b100,1'b0}] = 3'b011; output_z_table[{3'b100,1'b0}] = 1'b1;

        // For x=1 (LSB=1)
        next_state_table[{3'b000,1'b1}] = 3'b001; output_z_table[{3'b000,1'b1}] = 1'b0;
        next_state_table[{3'b001,1'b1}] = 3'b100; output_z_table[{3'b001,1'b1}] = 1'b0;
        next_state_table[{3'b010,1'b1}] = 3'b001; output_z_table[{3'b010,1'b1}] = 1'b0;
        next_state_table[{3'b011,1'b1}] = 3'b010; output_z_table[{3'b011,1'b1}] = 1'b1;
        next_state_table[{3'b100,1'b1}] = 3'b100; output_z_table[{3'b100,1'b1}] = 1'b1;
    end

    wire [3:0] idx = {y, x};
    wire [2:0] next_state = next_state_table[idx];

    always @(*) begin
        z = output_z_table[idx];
    end

    assign Y0 = next_state[0];

endmodule