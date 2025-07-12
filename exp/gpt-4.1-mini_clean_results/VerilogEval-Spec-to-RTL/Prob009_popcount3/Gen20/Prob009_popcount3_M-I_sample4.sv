module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    wire parity;
    wire majority;

    // parity bit: XOR of all three bits
    assign parity = in[0] ^ in[1] ^ in[2];
    // majority bit: any two or more bits are '1'
    assign majority = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

    assign out = {majority, parity};
endmodule