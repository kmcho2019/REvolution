module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // ROM implementation using a case statement
    reg [3:0] rom [0:15]; // 16 entries (3-bit y + 1-bit x) x 4-bit output (3-bit next state + 1-bit z)

    // Initialize ROM contents
    integer i;
    initial begin
        // Format: {next_state, z}
        // Address format: {y[2:0], x}
        rom[4'b0000] = {3'b000, 1'b0}; // y=000, x=0
        rom[4'b0001] = {3'b001, 1'b0}; // y=000, x=1
        rom[4'b0010] = {3'b001, 1'b0}; // y=001, x=0
        rom[4'b0011] = {3'b100, 1'b0}; // y=001, x=1
        rom[4'b0100] = {3'b010, 1'b0}; // y=010, x=0
        rom[4'b0101] = {3'b001, 1'b0}; // y=010, x=1
        rom[4'b0110] = {3'b001, 1'b1}; // y=011, x=0
        rom[4'b0111] = {3'b010, 1'b1}; // y=011, x=1
        rom[4'b1000] = {3'b011, 1'b1}; // y=100, x=0
        rom[4'b1001] = {3'b100, 1'b1}; // y=100, x=1
        
        // Default cases (should never occur in normal operation)
        for (i = 10; i < 16; i = i + 1)
            rom[i] = {3'b000, 1'b0};
    end

    // ROM access
    wire [3:0] rom_out = rom[{y, x}];

    // Output assignments
    assign Y0 = rom_out[0]; // Next state's LSB
    assign z = rom_out[3];  // Output z from ROM

endmodule