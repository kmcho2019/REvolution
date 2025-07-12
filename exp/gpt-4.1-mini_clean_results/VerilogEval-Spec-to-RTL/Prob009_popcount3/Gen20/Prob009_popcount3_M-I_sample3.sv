module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    wire a = in[0];
    wire b = in[1];
    wire c = in[2];

    assign out[0] = a ^ b ^ c;                 // LSB: parity of inputs (count odd)
    assign out[1] = (a & b) | (b & c) | (a & c); // MSB: at least two inputs are '1'

endmodule