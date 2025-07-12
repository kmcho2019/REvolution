module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Create a temporary 2D array for all comparisons
    wire [4:0] inputs = {a, b, c, d, e};
    wire [24:0] temp_out;

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                assign temp_out[i*5 + j] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

    // Flatten the 2D array into the output
    assign out = temp_out;

endmodule