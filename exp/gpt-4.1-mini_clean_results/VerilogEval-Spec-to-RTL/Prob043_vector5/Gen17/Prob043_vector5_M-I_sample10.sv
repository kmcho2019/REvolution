module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs with inputs[0] = a, inputs[1] = b, ..., inputs[4] = e
    wire [4:0] inputs = {a, b, c, d, e};

    // Function to get output bit index for (i,j): 24 - (5*i + j)
    // Instead of a function, explicitly assign each bit in order.

    assign out = {
        ~(inputs[0] ^ inputs[0]), // out[24]: a vs a
        ~(inputs[0] ^ inputs[1]), // out[23]: a vs b
        ~(inputs[0] ^ inputs[2]), // out[22]: a vs c
        ~(inputs[0] ^ inputs[3]), // out[21]: a vs d
        ~(inputs[0] ^ inputs[4]), // out[20]: a vs e

        ~(inputs[1] ^ inputs[0]), // out[19]: b vs a
        ~(inputs[1] ^ inputs[1]), // out[18]: b vs b
        ~(inputs[1] ^ inputs[2]), // out[17]: b vs c
        ~(inputs[1] ^ inputs[3]), // out[16]: b vs d
        ~(inputs[1] ^ inputs[4]), // out[15]: b vs e

        ~(inputs[2] ^ inputs[0]), // out[14]: c vs a
        ~(inputs[2] ^ inputs[1]), // out[13]: c vs b
        ~(inputs[2] ^ inputs[2]), // out[12]: c vs c
        ~(inputs[2] ^ inputs[3]), // out[11]: c vs d
        ~(inputs[2] ^ inputs[4]), // out[10]: c vs e

        ~(inputs[3] ^ inputs[0]), // out[9]: d vs a
        ~(inputs[3] ^ inputs[1]), // out[8]: d vs b
        ~(inputs[3] ^ inputs[2]), // out[7]: d vs c
        ~(inputs[3] ^ inputs[3]), // out[6]: d vs d
        ~(inputs[3] ^ inputs[4]), // out[5]: d vs e

        ~(inputs[4] ^ inputs[0]), // out[4]: e vs a
        ~(inputs[4] ^ inputs[1]), // out[3]: e vs b
        ~(inputs[4] ^ inputs[2]), // out[2]: e vs c
        ~(inputs[4] ^ inputs[3]), // out[1]: e vs d
        ~(inputs[4] ^ inputs[4])  // out[0]: e vs e
    };
endmodule