module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // ROM definition
    reg [3:0] rom [0:15]; // 16 entries (4-bit: 3 for next state, 1 for z)
    
    // Initialize ROM with FSM behavior
    initial begin
        // Format: {next_state[2:0], z}
        rom[4'b0000] = 4'b0000; // y=000, x=0
        rom[4'b0001] = 4'b0010; // y=000, x=1
        rom[4'b0010] = 4'b0010; // y=001, x=0
        rom[4'b0011] = 4'b1000; // y=001, x=1
        rom[4'b0100] = 4'b0100; // y=010, x=0
        rom[4'b0101] = 4'b0010; // y=010, x=1
        rom[4'b0110] = 4'b0011; // y=011, x=0
        rom[4'b0111] = 4'b0101; // y=011, x=1
        rom[4'b1000] = 4'b0111; // y=100, x=0
        rom[4'b1001] = 4'b1001; // y=100, x=1
        // Default cases (unused states)
        rom[4'b1010] = 4'b0000;
        rom[4'b1011] = 4'b0000;
        rom[4'b1100] = 4'b0000;
        rom[4'b1101] = 4'b0000;
        rom[4'b1110] = 4'b0000;
        rom[4'b1111] = 4'b0000;
    end

    // Form ROM address: {y[2:0], x}
    wire [3:0] rom_addr = {y, x};
    wire [3:0] rom_out = rom[rom_addr];

    // Output assignments
    assign Y0 = rom_out[0]; // Next state LSB
    assign z = rom_out[3];  // Output bit

endmodule