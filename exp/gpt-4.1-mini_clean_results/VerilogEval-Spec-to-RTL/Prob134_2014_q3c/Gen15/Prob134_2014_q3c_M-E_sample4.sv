module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Define ROM with 16 entries, each 4 bits: {z, Y[2], Y[1], Y[0]}
    // Address = {y[2:0], x}
    reg [3:0] rom [0:15];

    initial begin
        // Initialize all entries to zero (next state=000, z=0)
        integer i;
        for (i = 0; i < 16; i = i + 1) begin
            rom[i] = 4'b0000;
        end

        // Fill in the table based on the problem specification:
        // Address = {y, x}

        // y=000 (0)
        // x=0 -> next_state=000 (0), z=0
        rom[{3'b000,1'b0}] = 4'b0_000; // z=0, Y=000
        // x=1 -> next_state=001 (1), z=0
        rom[{3'b000,1'b1}] = 4'b0_001;

        // y=001 (1)
        // x=0 -> next_state=001 (1), z=0
        rom[{3'b001,1'b0}] = 4'b0_001;
        // x=1 -> next_state=100 (4), z=0
        rom[{3'b001,1'b1}] = 4'b0_100;

        // y=010 (2)
        // x=0 -> next_state=010 (2), z=0
        rom[{3'b010,1'b0}] = 4'b0_010;
        // x=1 -> next_state=001 (1), z=0
        rom[{3'b010,1'b1}] = 4'b0_001;

        // y=011 (3)
        // x=0 -> next_state=001 (1), z=1
        rom[{3'b011,1'b0}] = 4'b1_001;
        // x=1 -> next_state=010 (2), z=1
        rom[{3'b011,1'b1}] = 4'b1_010;

        // y=100 (4)
        // x=0 -> next_state=011 (3), z=1
        rom[{3'b100,1'b0}] = 4'b1_011;
        // x=1 -> next_state=100 (4), z=1
        rom[{3'b100,1'b1}] = 4'b1_100;
    end

    wire [3:0] rom_data = rom[{y, x}];

    // rom_data format: {z, Y2, Y1, Y0}
    assign z = rom_data[3];
    assign Y0 = rom_data[0];

endmodule