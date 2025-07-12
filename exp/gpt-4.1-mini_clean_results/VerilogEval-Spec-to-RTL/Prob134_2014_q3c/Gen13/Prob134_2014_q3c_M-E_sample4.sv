module TopModule (
    input        clk,   // clock input (not used)
    input        x,
    input  [2:0] y,     // present state
    output       Y0,
    output       z
);

    // Define the total address width: present state (3 bits) + input x (1 bit) = 4 bits
    wire [3:0] addr = {y, x};

    // ROM for next state: 16 entries (4-bit address), each 3 bits
    reg [2:0] next_state_rom [0:15];

    // ROM for output z: 16 entries (4-bit address), each 1 bit
    reg z_rom [0:15];

    initial begin
        // Initialize next_state_rom based on the FSM table
        // When present state y and x are:
        // y=000 (0), x=0 -> next_state=000 (0)
        next_state_rom[4'b0000] = 3'b000;
        // y=000 (0), x=1 -> next_state=001 (1)
        next_state_rom[4'b0001] = 3'b001;

        // y=001 (1), x=0 -> next_state=001 (1)
        next_state_rom[4'b0010] = 3'b001;
        // y=001 (1), x=1 -> next_state=100 (4)
        next_state_rom[4'b0011] = 3'b100;

        // y=010 (2), x=0 -> next_state=010 (2)
        next_state_rom[4'b0100] = 3'b010;
        // y=010 (2), x=1 -> next_state=001 (1)
        next_state_rom[4'b0101] = 3'b001;

        // y=011 (3), x=0 -> next_state=001 (1)
        next_state_rom[4'b0110] = 3'b001;
        // y=011 (3), x=1 -> next_state=010 (2)
        next_state_rom[4'b0111] = 3'b010;

        // y=100 (4), x=0 -> next_state=011 (3)
        next_state_rom[4'b1000] = 3'b011;
        // y=100 (4), x=1 -> next_state=100 (4)
        next_state_rom[4'b1001] = 3'b100;

        // For unused states (101, 110, 111), assign next state to 000
        next_state_rom[4'b1010] = 3'b000;
        next_state_rom[4'b1011] = 3'b000;
        next_state_rom[4'b1100] = 3'b000;
        next_state_rom[4'b1101] = 3'b000;
        next_state_rom[4'b1110] = 3'b000;
        next_state_rom[4'b1111] = 3'b000;

        // Initialize z_rom based on present state only (ignore x since z depends only on present state)
        // Set z=0 for y = 000, 001, 010; z=1 for y = 011, 100
        z_rom[4'b0000] = 1'b0; // y=000, x=0
        z_rom[4'b0001] = 1'b0; // y=000, x=1

        z_rom[4'b0010] = 1'b0; // y=001, x=0
        z_rom[4'b0011] = 1'b0; // y=001, x=1

        z_rom[4'b0100] = 1'b0; // y=010, x=0
        z_rom[4'b0101] = 1'b0; // y=010, x=1

        z_rom[4'b0110] = 1'b1; // y=011, x=0
        z_rom[4'b0111] = 1'b1; // y=011, x=1

        z_rom[4'b1000] = 1'b1; // y=100, x=0
        z_rom[4'b1001] = 1'b1; // y=100, x=1

        // For unused states, output 0 for z
        z_rom[4'b1010] = 1'b0;
        z_rom[4'b1011] = 1'b0;
        z_rom[4'b1100] = 1'b0;
        z_rom[4'b1101] = 1'b0;
        z_rom[4'b1110] = 1'b0;
        z_rom[4'b1111] = 1'b0;
    end

    wire [2:0] next_state = next_state_rom[addr];
    wire       z_out      = z_rom[addr];

    assign Y0 = next_state[0];
    assign z  = z_out;

endmodule