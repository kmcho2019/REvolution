module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Initialize all output bits to 0
    assign out_both[99] = 0;
    assign out_any[0] = 0;

    // Calculate out_both
    genvar i;
    generate
        for (i = 98; i >= 0; i = i - 1) begin
            assign out_both[i] = in[i] & in[i + 1];
        end
    endgenerate

    // Calculate out_any
    genvar j;
    generate
        for (j = 1; j <= 99; j = j + 1) begin
            assign out_any[j] = in[j] | in[j - 1];
        end
    endgenerate

    // Calculate out_different
    genvar k;
    generate
        for (k = 99; k >= 0; k = k - 1) begin
            if (k == 99) begin
                assign out_different[k] = in[k] != in[0];
            end else begin
                assign out_different[k] = in[k] != in[k + 1];
            end
        end
    endgenerate

endmodule