module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Define inputs in order for indexing: 0=a,1=b,2=c,3=d,4=e
    wire [4:0] in = {a, b, c, d, e};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                // Map output bits: out[24] = a vs a at (i=0,j=0), down to out[0] = e vs e at (i=4,j=4)
                assign out[24 - (5*i + j)] = ~(in[i] ^ in[j]);
            end
        end
    endgenerate
endmodule