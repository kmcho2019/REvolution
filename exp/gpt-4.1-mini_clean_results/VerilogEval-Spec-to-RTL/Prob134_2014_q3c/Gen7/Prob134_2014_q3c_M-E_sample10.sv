module TopModule (
    input clk,            // clock input (unused internally)
    input x,
    input [2:0] y,        // present state input
    output Y0,
    output z
);

    // Combine present state y and input x into a 4-bit address: {y, x}
    wire [3:0] addr = {y, x};

    // Memory to hold {next_state[2:0], z} for each addr
    // Format: bits [3:1] = next_state[2:0], bit [0] = z output
    reg [3:0] lut [0:15];

    initial begin
        // Initialize LUT with defaults (all zeros)
        integer i;
        for (i = 0; i < 16; i = i + 1)
            lut[i] = 4'b0000;

        // Populate LUT entries based on the FSM table
        // addr = {y[2:0], x}

        // y=000 (0)
        lut[4'b0000] = {3'b000, 1'b0}; // x=0 -> next=000, z=0
        lut[4'b0001] = {3'b001, 1'b0}; // x=1 -> next=001, z=0

        // y=001 (1)
        lut[4'b0010] = {3'b001, 1'b0}; // x=0 -> next=001, z=0
        lut[4'b0011] = {3'b100, 1'b0}; // x=1 -> next=100, z=0

        // y=010 (2)
        lut[4'b0100] = {3'b010, 1'b0}; // x=0 -> next=010, z=0
        lut[4'b0101] = {3'b001, 1'b0}; // x=1 -> next=001, z=0

        // y=011 (3)
        lut[4'b0110] = {3'b001, 1'b1}; // x=0 -> next=001, z=1
        lut[4'b0111] = {3'b010, 1'b1}; // x=1 -> next=010, z=1

        // y=100 (4)
        lut[4'b1000] = {3'b011, 1'b1}; // x=0 -> next=011, z=1
        lut[4'b1001] = {3'b100, 1'b1}; // x=1 -> next=100, z=1
    end

    wire [3:0] out = lut[addr];

    // next state is bits [3:1]
    wire [2:0] next_state = out[3:1];

    // output z is bit [0]
    assign z = out[0];

    // Y0 is LSB of next state
    assign Y0 = next_state[0];

endmodule