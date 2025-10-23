module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Initialize out_both[99] to 0
    assign out_both[99] = 1'b0;

    // Initialize out_any[0] to 0
    assign out_any[0] = 1'b0;

    // Calculate out_both
    genvar i;
    generate
        for (i = 98; i >= 0; i = i - 1) begin
            assign out_both[i] = in[i] & in[i + 1];
        end
    endgenerate

    // Calculate out_any
    generate
        for (i = 1; i <= 99; i = i + 1) begin
            assign out_any[i] = in[i] | in[i - 1];
        end
    endgenerate

    // Calculate out_different
    assign out_different[99] = in[99] ^ in[0];
    generate
        for (i = 98; i >= 0; i = i - 1) begin
            assign out_different[i] = in[i] ^ in[i + 1];
        end
    endgenerate

endmodule