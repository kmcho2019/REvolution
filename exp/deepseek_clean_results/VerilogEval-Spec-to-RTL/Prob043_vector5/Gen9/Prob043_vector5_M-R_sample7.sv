module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);
    wire [4:0] inputs = {e, d, c, b, a};
    genvar i, j;
    
    generate
        for (i = 0; i < 5; i = i + 1) begin : outer
            for (j = 0; j < 5; j = j + 1) begin : inner
                assign out[(4-i)*5 + (4-j)] = inputs[i] ~^ inputs[j];
            end
        end
    endgenerate
endmodule