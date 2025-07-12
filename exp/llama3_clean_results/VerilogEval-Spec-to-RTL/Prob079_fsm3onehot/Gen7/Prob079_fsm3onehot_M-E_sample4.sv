module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Define the ROM contents based on the state transition table
    reg [3:0] rom [7:0]; // 8 entries for 2^3 (state and input) combinations
    initial begin
        // State A
        rom[0] = 4'b0001; // in=0, next_state=A, out=0
        rom[1] = 4'b0010; // in=1, next_state=B, out=0
        // State B
        rom[2] = 4'b0100; // in=0, next_state=C, out=0
        rom[3] = 4'b0010; // in=1, next_state=B, out=0
        // State C
        rom[4] = 4'b0001; // in=0, next_state=A, out=0
        rom[5] = 4'b1000; // in=1, next_state=D, out=1
        // State D
        rom[6] = 4'b0100; // in=0, next_state=C, out=1
        rom[7] = 4'b0010; // in=1, next_state=B, out=1
    end

    // Generate the address for the ROM based on the current state and input
    wire [2:0] addr;
    assign addr = {in, state[0], state[1]}; // Assuming state[2] and state[3] are always 0 for one-hot encoding

    // Access the ROM to get the next state and output
    assign next_state = rom[addr];
    assign out = (rom[addr] == 4'b1000)? 1'b1 : 1'b0;

endmodule