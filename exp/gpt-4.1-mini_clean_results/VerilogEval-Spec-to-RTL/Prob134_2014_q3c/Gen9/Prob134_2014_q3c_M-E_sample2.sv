module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Combine present state y and input x into address for ROM (5 bits)
    wire [4:0] addr = {y, x};

    // ROM data: 32 entries, each 4 bits: {z, Y2, Y1, Y0}
    // Initialize ROM with default next state 000 and z=0
    reg [3:0] rom [0:31];

    initial begin
        integer i;
        for(i=0; i<32; i=i+1) begin
            rom[i] = 4'b0000; // default: z=0, next_state=000
        end
        // Fill valid states with correct values from FSM table:

        // y=000
        rom[{3'b000,1'b0}] = 4'b0_000; // x=0: next=000,z=0
        rom[{3'b000,1'b1}] = 4'b0_001; // x=1: next=001,z=0

        // y=001
        rom[{3'b001,1'b0}] = 4'b0_001; // x=0: next=001,z=0
        rom[{3'b001,1'b1}] = 4'b0_100; // x=1: next=100,z=0

        // y=010
        rom[{3'b010,1'b0}] = 4'b0_010; // x=0: next=010,z=0
        rom[{3'b010,1'b1}] = 4'b0_001; // x=1: next=001,z=0

        // y=011
        rom[{3'b011,1'b0}] = 4'b1_001; // x=0: next=001,z=1
        rom[{3'b011,1'b1}] = 4'b1_010; // x=1: next=010,z=1

        // y=100
        rom[{3'b100,1'b0}] = 4'b1_011; // x=0: next=011,z=1
        rom[{3'b100,1'b1}] = 4'b1_100; // x=1: next=100,z=1
    end

    wire [3:0] rom_out = rom[addr];

    assign z  = rom_out[3];
    assign Y0 = rom_out[0];

endmodule