module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] in_vec = {a,b,c,d,e};

    genvar i,j;
    generate
        for(i=0; i<5; i=i+1) begin : ROWS
            for(j=0; j<5; j=j+1) begin : COLS
                // Output bit index: row-major order, highest bit = a vs a (0,0)
                // out[24] = eq(a,a) = ~(a ^ a), out[23] = eq(a,b) = ~(a ^ b), etc.
                assign out[24 - (5*i + j)] = ~(in_vec[i] ^ in_vec[j]);
            end
        end
    endgenerate

endmodule