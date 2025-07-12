module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] inputs = {a, b, c, d, e};
    wire [24:0] cmp;

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin: row
            for (j = 0; j < 5; j = j + 1) begin: col
                // Calculate index in out vector
                localparam idx = 5 * (4 - i) + (4 - j); // To match out[24:0] order (a=4...e=0)
                if (j >= i) begin
                    assign cmp[idx] = ~(inputs[i] ^ inputs[j]); // upper triangle and diagonal
                end else begin
                    localparam mirror_idx = 5 * (4 - j) + (4 - i);
                    assign cmp[idx] = cmp[mirror_idx]; // mirror lower triangle from upper triangle
                end
            end
        end
    endgenerate

    assign out = cmp;

endmodule