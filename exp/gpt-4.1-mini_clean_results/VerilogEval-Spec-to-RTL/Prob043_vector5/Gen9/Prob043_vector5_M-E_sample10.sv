module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);

    // Pack inputs in natural order: a=inputs[0], b=inputs[1], ..., e=inputs[4]
    wire [4:0] inputs = {a, b, c, d, e};

    // Function for bitwise XNOR (equality)
    function automatic bit xnor_bit(input bit x, input bit y);
        xnor_bit = ~(x ^ y);
    endfunction

    // Assign each output bit explicitly:
    assign out[24] = xnor_bit(inputs[0], inputs[0]); // a,a
    assign out[23] = xnor_bit(inputs[0], inputs[1]); // a,b
    assign out[22] = xnor_bit(inputs[0], inputs[2]); // a,c
    assign out[21] = xnor_bit(inputs[0], inputs[3]); // a,d
    assign out[20] = xnor_bit(inputs[0], inputs[4]); // a,e

    assign out[19] = xnor_bit(inputs[1], inputs[0]); // b,a
    assign out[18] = xnor_bit(inputs[1], inputs[1]); // b,b
    assign out[17] = xnor_bit(inputs[1], inputs[2]); // b,c
    assign out[16] = xnor_bit(inputs[1], inputs[3]); // b,d
    assign out[15] = xnor_bit(inputs[1], inputs[4]); // b,e

    assign out[14] = xnor_bit(inputs[2], inputs[0]); // c,a
    assign out[13] = xnor_bit(inputs[2], inputs[1]); // c,b
    assign out[12] = xnor_bit(inputs[2], inputs[2]); // c,c
    assign out[11] = xnor_bit(inputs[2], inputs[3]); // c,d
    assign out[10] = xnor_bit(inputs[2], inputs[4]); // c,e

    assign out[9]  = xnor_bit(inputs[3], inputs[0]); // d,a
    assign out[8]  = xnor_bit(inputs[3], inputs[1]); // d,b
    assign out[7]  = xnor_bit(inputs[3], inputs[2]); // d,c
    assign out[6]  = xnor_bit(inputs[3], inputs[3]); // d,d
    assign out[5]  = xnor_bit(inputs[3], inputs[4]); // d,e

    assign out[4]  = xnor_bit(inputs[4], inputs[0]); // e,a
    assign out[3]  = xnor_bit(inputs[4], inputs[1]); // e,b
    assign out[2]  = xnor_bit(inputs[4], inputs[2]); // e,c
    assign out[1]  = xnor_bit(inputs[4], inputs[3]); // e,d
    assign out[0]  = xnor_bit(inputs[4], inputs[4]); // e,e

endmodule