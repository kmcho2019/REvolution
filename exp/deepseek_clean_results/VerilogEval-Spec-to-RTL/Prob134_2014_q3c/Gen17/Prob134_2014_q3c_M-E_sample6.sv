module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // ROM width: 4 bits (3 for next state + 1 for z)
    reg [3:0] rom [0:15]; // 16 possible addresses (3 state bits + 1 input bit)
    
    // Initialize ROM contents
    initial begin
        // Address format: {y[2:0], x}
        rom[4'b0000] = 4'b0000; // y=000, x=0 → next=000, z=0
        rom[4'b0001] = 4'b0010; // y=000, x=1 → next=001, z=0
        rom[4'b0010] = 4'b0010; // y=001, x=0 → next=001, z=0
        rom[4'b0011] = 4'b1000; // y=001, x=1 → next=100, z=0
        rom[4'b0100] = 4'b0100; // y=010, x=0 → next=010, z=0
        rom[4'b0101] = 4'b0010; // y=010, x=1 → next=001, z=0
        rom[4'b0110] = 4'b0011; // y=011, x=0 → next=001, z=1
        rom[4'b0111] = 4'b0101; // y=011, x=1 → next=010, z=1
        rom[4'b1000] = 4'b0111; // y=100, x=0 → next=011, z=1
        rom[4'b1001] = 4'b1001; // y=100, x=1 → next=100, z=1
        // Default cases (shouldn't occur in normal operation)
        rom[4'b1010] = 4'b0000;
        rom[4'b1011] = 4'b0000;
        rom[4'b1100] = 4'b0000;
        rom[4'b1101] = 4'b0000;
        rom[4'b1110] = 4'b0000;
        rom[4'b1111] = 4'b0000;
    end

    // ROM lookup
    wire [3:0] rom_out = rom[{y, x}];
    wire [2:0] next_state = rom_out[3:1];
    assign z = rom_out[0];
    assign Y0 = next_state[0];

endmodule