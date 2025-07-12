module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Create a 4-bit address from present state y and input x
    wire [3:0] addr = {y, x};

    // Define ROM contents as a parameter: 
    // For each addr, bits [6:4] = next_state[2:0], bit 3 = Y0 (= next_state[0]), bit 0 = output z
    // But since Y0 is next_state[0], store next_state[2:0] and z only, output Y0 from next_state[0]
    // We'll store [6:4] next_state[2:0], [3:0] reserved (z at bit0)
    // Actually, 4 bits per entry: 3 bits next_state + 1 bit z
    // We'll store 16 entries (addr 0 to 15)

    // Map from FSM table and default unused states to 000 and z=0:
    // Addr = {y[2:0], x}
    // For present states 000 to 100 only; for others default to next_state=000, z=0.

    localparam [15:0][3:0] FSM_TABLE = {
        4'b1111: 4'b0000, // y=111 unused -> next_state=000,z=0
        4'b1110: 4'b0000,
        4'b1101: 4'b0000,
        4'b1100: 4'b0000,
        // y=100
        4'b1001: 4'b1001, // y=100 x=1 next_state=100(z=1)
        4'b1000: 4'b0111, // y=100 x=0 next_state=011(z=1)
        // y=011
        4'b0111: 4'b0101, // y=011 x=1 next_state=010(z=1)
        4'b0110: 4'b0011, // y=011 x=0 next_state=001(z=1)
        // y=010
        4'b0101: 4'b0010, // y=010 x=1 next_state=001(z=0)
        4'b0100: 4'b0100, // y=010 x=0 next_state=010(z=0)
        // y=001
        4'b0011: 4'b1000, // y=001 x=1 next_state=100(z=0)
        4'b0010: 4'b0010, // y=001 x=0 next_state=001(z=0)
        // y=000
        4'b0001: 4'b0010, // y=000 x=1 next_state=001(z=0)
        4'b0000: 4'b0000, // y=000 x=0 next_state=000(z=0)
        // default all others to zero
        4'b1011: 4'b0000,
        4'b1010: 4'b0000,
        4'b1101: 4'b0000,
        4'b1100: 4'b0000,
        4'b1111: 4'b0000,
        4'b1110: 4'b0000
    };

    // Since Verilog does not support packed arrays in all tools, 
    // define as a function with case statement for portability:

    function [3:0] lookup;
        input [3:0] addr_in;
        begin
            case(addr_in)
                4'b0000: lookup = 4'b0000; // y=000 x=0: next_state=000 z=0
                4'b0001: lookup = 4'b0010; // y=000 x=1: next_state=001 z=0
                4'b0010: lookup = 4'b0010; // y=001 x=0: next_state=001 z=0
                4'b0011: lookup = 4'b1000; // y=001 x=1: next_state=100 z=0
                4'b0100: lookup = 4'b0100; // y=010 x=0: next_state=010 z=0
                4'b0101: lookup = 4'b0010; // y=010 x=1: next_state=001 z=0
                4'b0110: lookup = 4'b0011; // y=011 x=0: next_state=001 z=1
                4'b0111: lookup = 4'b0101; // y=011 x=1: next_state=010 z=1
                4'b1000: lookup = 4'b0111; // y=100 x=0: next_state=011 z=1
                4'b1001: lookup = 4'b1001; // y=100 x=1: next_state=100 z=1
                default: lookup = 4'b0000; // undefined states to zero
            endcase
        end
    endfunction

    wire [3:0] entry = lookup(addr);

    // Extract next_state and output z
    wire [2:0] next_state = entry[3:1]; // bits 3:1 = next_state[2:0]
    wire z_int = entry[0];

    assign z = z_int;
    assign Y0 = next_state[0];

endmodule