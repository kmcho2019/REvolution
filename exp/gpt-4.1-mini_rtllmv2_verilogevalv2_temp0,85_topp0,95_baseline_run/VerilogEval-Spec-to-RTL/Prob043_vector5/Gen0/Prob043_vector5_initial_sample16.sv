module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] inputs = {a,b,c,d,e};

    genvar i, j;
    generate
        for (i=0; i<5; i=i+1) begin : outer
            for (j=0; j<5; j=j+1) begin : inner
                // index for output bit: 24 - (i*5 + j)
                // Compare inputs[i] with inputs[j]
                assign out[24 - (i*5 + j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule