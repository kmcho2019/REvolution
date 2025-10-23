module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};  // a=inputs[4], e=inputs[0] is reversed, so reorder to a=0

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                // Output index is i*5 + j
                assign out[i*5 + j] = inputs[i] ^~ inputs[j];  // XNOR operator ^~
            end
        end
    endgenerate
endmodule