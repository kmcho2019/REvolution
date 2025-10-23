module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);

    // Pack inputs into an array for indexed access (inputs[0]=a,...inputs[4]=e)
    wire [0:4] inputs;
    assign inputs[0] = a;
    assign inputs[1] = b;
    assign inputs[2] = c;
    assign inputs[3] = d;
    assign inputs[4] = e;

    // Function to compute bit equality (XNOR)
    function bit bit_equal(input bit x, input bit y);
        begin
            bit_equal = ~(x ^ y);
        end
    endfunction

    // Explicit assign statements for each output bit (total 25)
    // out[24 - (5*i + j)] = equality of inputs[i], inputs[j]
    assign out[24] = bit_equal(inputs[0], inputs[0]);  // a,a
    assign out[23] = bit_equal(inputs[0], inputs[1]);  // a,b
    assign out[22] = bit_equal(inputs[0], inputs[2]);  // a,c
    assign out[21] = bit_equal(inputs[0], inputs[3]);  // a,d
    assign out[20] = bit_equal(inputs[0], inputs[4]);  // a,e

    assign out[19] = bit_equal(inputs[1], inputs[0]);  // b,a
    assign out[18] = bit_equal(inputs[1], inputs[1]);  // b,b
    assign out[17] = bit_equal(inputs[1], inputs[2]);  // b,c
    assign out[16] = bit_equal(inputs[1], inputs[3]);  // b,d
    assign out[15] = bit_equal(inputs[1], inputs[4]);  // b,e

    assign out[14] = bit_equal(inputs[2], inputs[0]);  // c,a
    assign out[13] = bit_equal(inputs[2], inputs[1]);  // c,b
    assign out[12] = bit_equal(inputs[2], inputs[2]);  // c,c
    assign out[11] = bit_equal(inputs[2], inputs[3]);  // c,d
    assign out[10] = bit_equal(inputs[2], inputs[4]);  // c,e

    assign out[9]  = bit_equal(inputs[3], inputs[0]);  // d,a
    assign out[8]  = bit_equal(inputs[3], inputs[1]);  // d,b
    assign out[7]  = bit_equal(inputs[3], inputs[2]);  // d,c
    assign out[6]  = bit_equal(inputs[3], inputs[3]);  // d,d
    assign out[5]  = bit_equal(inputs[3], inputs[4]);  // d,e

    assign out[4]  = bit_equal(inputs[4], inputs[0]);  // e,a
    assign out[3]  = bit_equal(inputs[4], inputs[1]);  // e,b
    assign out[2]  = bit_equal(inputs[4], inputs[2]);  // e,c
    assign out[1]  = bit_equal(inputs[4], inputs[3]);  // e,d
    assign out[0]  = bit_equal(inputs[4], inputs[4]);  // e,e

endmodule