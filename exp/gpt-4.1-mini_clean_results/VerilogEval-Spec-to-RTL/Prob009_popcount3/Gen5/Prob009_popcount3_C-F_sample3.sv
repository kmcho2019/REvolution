module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Intermediate signals for clarity
    wire parity;   // LSB of population count: XOR of all bits
    wire majority; // MSB of population count: at least two bits set

    assign parity  = in[0] ^ in[1] ^ in[2];
    assign majority = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

    // Output encodes the number of '1's in 'in' as a 2-bit binary number
    assign out = {majority, parity};

endmodule