module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a,b,c,d,e};

    genvar i,j;
    generate
        for(i=0; i<5; i=i+1) begin : row
            for(j=0; j<5; j=j+1) begin : col
                // out index = (4 - i)*5 + (4 - j) based on example given (out[24]=a vs a)
                // We want out[24] = a vs a at i=0, j=0
                // So out index = 24 - (i*5 + j)
                // Then assign out[24 - (i*5 + j)] = ~(inputs[i] ^ inputs[j])
                assign out[24 - (i*5 + j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule