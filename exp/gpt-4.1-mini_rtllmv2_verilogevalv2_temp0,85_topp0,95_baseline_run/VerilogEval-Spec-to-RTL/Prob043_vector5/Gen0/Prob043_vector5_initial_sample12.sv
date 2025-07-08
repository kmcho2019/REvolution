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
    wire [24:0] result;

    generate
        for (i = 0; i < 5; i = i + 1) begin : outer
            for (j = 0; j < 5; j = j + 1) begin : inner
                // Calculate output index from (i,j) as 24 - (i*5 + j)
                // Because out[24] = compare(a,a) = (i=0,j=0)
                // So index = 24 - (5*i + j)
                assign result[24 - (5*i + j)] = ~(in_vec[i] ^ in_vec[j]);
            end
        end
    endgenerate

    assign out = result;
endmodule