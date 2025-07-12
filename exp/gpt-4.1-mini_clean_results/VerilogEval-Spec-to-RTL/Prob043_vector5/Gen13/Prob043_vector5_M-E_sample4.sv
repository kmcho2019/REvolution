module TopModule(
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
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                // Calculate output index for bit packing:
                // out[24] = in_vec[4] ~^ in_vec[4]
                // index = (4 - i)*5 + (4 - j)
                localparam integer out_idx = (4 - i)*5 + (4 - j);
                assign out[out_idx] = ~(in_vec[i] ^ in_vec[j]); // XNOR operator
            end
        end
    endgenerate
endmodule