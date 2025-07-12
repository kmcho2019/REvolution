module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] in_vec = {a, b, c, d, e};

    // For clarity, define each out bit explicitly as XNOR of the pair
    assign out[24] = ~(in_vec[4] ^ in_vec[4]); // a with a
    assign out[23] = ~(in_vec[4] ^ in_vec[3]); // a with b
    assign out[22] = ~(in_vec[4] ^ in_vec[2]); // a with c
    assign out[21] = ~(in_vec[4] ^ in_vec[1]); // a with d
    assign out[20] = ~(in_vec[4] ^ in_vec[0]); // a with e

    assign out[19] = ~(in_vec[3] ^ in_vec[4]); // b with a
    assign out[18] = ~(in_vec[3] ^ in_vec[3]); // b with b
    assign out[17] = ~(in_vec[3] ^ in_vec[2]); // b with c
    assign out[16] = ~(in_vec[3] ^ in_vec[1]); // b with d
    assign out[15] = ~(in_vec[3] ^ in_vec[0]); // b with e

    assign out[14] = ~(in_vec[2] ^ in_vec[4]); // c with a
    assign out[13] = ~(in_vec[2] ^ in_vec[3]); // c with b
    assign out[12] = ~(in_vec[2] ^ in_vec[2]); // c with c
    assign out[11] = ~(in_vec[2] ^ in_vec[1]); // c with d
    assign out[10] = ~(in_vec[2] ^ in_vec[0]); // c with e

    assign out[9]  = ~(in_vec[1] ^ in_vec[4]); // d with a
    assign out[8]  = ~(in_vec[1] ^ in_vec[3]); // d with b
    assign out[7]  = ~(in_vec[1] ^ in_vec[2]); // d with c
    assign out[6]  = ~(in_vec[1] ^ in_vec[1]); // d with d
    assign out[5]  = ~(in_vec[1] ^ in_vec[0]); // d with e

    assign out[4]  = ~(in_vec[0] ^ in_vec[4]); // e with a
    assign out[3]  = ~(in_vec[0] ^ in_vec[3]); // e with b
    assign out[2]  = ~(in_vec[0] ^ in_vec[2]); // e with c
    assign out[1]  = ~(in_vec[0] ^ in_vec[1]); // e with d
    assign out[0]  = ~(in_vec[0] ^ in_vec[0]); // e with e

endmodule