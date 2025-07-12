module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Pack inputs into a vector, inputs[4]=a ... inputs[0]=e
    wire [4:0] inputs = {a, b, c, d, e};

    // Assign each output bit explicitly: out[24 - (5*i + j)] = inputs[4 - i] XNOR inputs[4 - j]
    assign out[24] = inputs[4]  ~^ inputs[4];  // a vs a
    assign out[23] = inputs[4]  ~^ inputs[3];  // a vs b
    assign out[22] = inputs[4]  ~^ inputs[2];  // a vs c
    assign out[21] = inputs[4]  ~^ inputs[1];  // a vs d
    assign out[20] = inputs[4]  ~^ inputs[0];  // a vs e

    assign out[19] = inputs[3]  ~^ inputs[4];  // b vs a
    assign out[18] = inputs[3]  ~^ inputs[3];  // b vs b
    assign out[17] = inputs[3]  ~^ inputs[2];  // b vs c
    assign out[16] = inputs[3]  ~^ inputs[1];  // b vs d
    assign out[15] = inputs[3]  ~^ inputs[0];  // b vs e

    assign out[14] = inputs[2]  ~^ inputs[4];  // c vs a
    assign out[13] = inputs[2]  ~^ inputs[3];  // c vs b
    assign out[12] = inputs[2]  ~^ inputs[2];  // c vs c
    assign out[11] = inputs[2]  ~^ inputs[1];  // c vs d
    assign out[10] = inputs[2]  ~^ inputs[0];  // c vs e

    assign out[9]  = inputs[1]  ~^ inputs[4];  // d vs a
    assign out[8]  = inputs[1]  ~^ inputs[3];  // d vs b
    assign out[7]  = inputs[1]  ~^ inputs[2];  // d vs c
    assign out[6]  = inputs[1]  ~^ inputs[1];  // d vs d
    assign out[5]  = inputs[1]  ~^ inputs[0];  // d vs e

    assign out[4]  = inputs[0]  ~^ inputs[4];  // e vs a
    assign out[3]  = inputs[0]  ~^ inputs[3];  // e vs b
    assign out[2]  = inputs[0]  ~^ inputs[2];  // e vs c
    assign out[1]  = inputs[0]  ~^ inputs[1];  // e vs d
    assign out[0]  = inputs[0]  ~^ inputs[0];  // e vs e

endmodule