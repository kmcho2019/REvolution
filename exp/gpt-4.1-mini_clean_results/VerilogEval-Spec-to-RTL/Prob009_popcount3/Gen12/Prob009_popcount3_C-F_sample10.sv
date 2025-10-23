module TopModule (
    input  [2:0] in,
    output wire [1:0] out
);

    // Intermediate signal: parity bit - XOR of all input bits, representing LSB of population count
    wire parity = in[0] ^ in[1] ^ in[2];

    // Intermediate signal: majority bit - true if at least two inputs are high, representing MSB of population count
    wire majority = (in[0] & in[1]) | (in[1] & in[2]) | (in[2] & in[0]);

    // Assign output as concatenation of majority (MSB) and parity (LSB)
    assign out = {majority, parity};

endmodule