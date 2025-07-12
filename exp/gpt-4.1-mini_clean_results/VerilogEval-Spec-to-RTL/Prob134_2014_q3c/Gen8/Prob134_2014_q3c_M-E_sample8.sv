module TopModule (
    input        clk,    // clock input (unused internally)
    input        x,
    input  [2:0] y,      // present state input
    output       Y0,
    output       z
);

    // ROM-like packed data storing {next_state[2:0], output_z} for each present state and input x
    // Index calculation: {y, x} as 4-bit address (y:3 bits, x:1 bit)
    // For each (y,x): data = {next_state[2:0], z}
    // Using concatenation and initialization to build a lookup table
    reg [3:0] fsm_rom [0:15]; 

    initial begin
        // y=000 (0): x=0->next=000,z=0; x=1->next=001,z=0
        fsm_rom[4'b0000] = 4'b0000; // next=000(3 bits), z=0
        fsm_rom[4'b0001] = 4'b0010; // next=001(3 bits), z=0

        // y=001 (1): x=0->next=001,z=0; x=1->next=100,z=0
        fsm_rom[4'b0010] = 4'b0010;
        fsm_rom[4'b0011] = 4'b1000;

        // y=010 (2): x=0->next=010,z=0; x=1->next=001,z=0
        fsm_rom[4'b0100] = 4'b0100;
        fsm_rom[4'b0101] = 4'b0010;

        // y=011 (3): x=0->next=001,z=1; x=1->next=010,z=1
        fsm_rom[4'b0110] = 4'b0011;
        fsm_rom[4'b0111] = 4'b0101;

        // y=100 (4): x=0->next=011,z=1; x=1->next=100,z=1
        fsm_rom[4'b1000] = 4'b0111;
        fsm_rom[4'b1001] = 4'b1001;

        // For unused states (y=101,110,111), assign zero output and next state
        fsm_rom[4'b1010] = 4'b0000;
        fsm_rom[4'b1011] = 4'b0000;
        fsm_rom[4'b1100] = 4'b0000;
        fsm_rom[4'b1101] = 4'b0000;
        fsm_rom[4'b1110] = 4'b0000;
        fsm_rom[4'b1111] = 4'b0000;
    end

    wire [3:0] rom_out;
    assign rom_out = fsm_rom[{y, x}];

    wire [2:0] next_state = rom_out[3:1];
    assign z = rom_out[0];
    assign Y0 = next_state[0];

endmodule