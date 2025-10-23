module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] in_vec = {a,b,c,d,e};
    genvar i, j;
    // We'll assign out bits from 24 down to 0 using nested loops in generate block
    // out[25*(4-i) + (4-j)] = XNOR(in_vec[i], in_vec[j])
    // Because when i=0 (a), j=0..4: indices 24 down to 20
    // When i=4 (e), j=0..4: indices 4 down to 0
    generate
        for (i=0; i<5; i=i+1) begin : row_loop
            for (j=0; j<5; j=j+1) begin : col_loop
                // compute bit index in out vector
                // index = 25*(4-i) + (4-j) - No, that overflows
                // The matrix is 5x5 bits, numbered 24..0
                // Let's assign: out[24 - (5*i + j)] = XNOR(in_vec[i], in_vec[j])
                // Because we want out[24] = (a vs a), which is (i=0,j=0)
                assign out[24 - (5*i + j)] = ~(in_vec[i] ^ in_vec[j]);
            end
        end
    endgenerate
endmodule