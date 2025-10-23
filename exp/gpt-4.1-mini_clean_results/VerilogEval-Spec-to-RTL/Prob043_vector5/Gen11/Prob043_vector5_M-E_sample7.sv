module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] in_vec;
    assign in_vec = {a, b, c, d, e};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : outer_loop
            for (j = 0; j < 5; j = j + 1) begin : inner_loop
                // Calculate output index as specified: out[24 - (5*i + j)]
                assign out[24 - (5*i + j)] = ~(in_vec[i] ^ in_vec[j]);
            end
        end
    endgenerate

endmodule