module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Population count for 3 bits outputs a value from 0 to 3 (2 bits)
    // out[0] (LSB): parity bit = XOR of all input bits
    // out[1] (MSB): majority bit = 1 if at least two inputs are 1

    assign out[0] = in[0] ^ in[1] ^ in[2];
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

    // Note: This logic is equivalent to the arithmetic sum:
    // assign out = in[0] + in[1] + in[2];
    // but using explicit boolean expressions may lead to smaller, faster combinational logic.

endmodule