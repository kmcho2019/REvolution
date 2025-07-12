module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Handle the edge case for the first bit
    assign out_both[0] = 1'b0;
    assign out_any[0] = 1'b0;
    assign out_different[0] = in[0] ^ in[99];

    // Handle the edge case for the last bit
    assign out_both[99] = 1'b0;
    assign out_any[99] = in[98] | in[99];
    assign out_different[99] = in[99] ^ in[0];

    // Generate logic for the middle bits
    genvar i;
    generate
        for (i = 1; i < 99; i++) begin
            assign out_both[i] = in[i] & in[i+1];
            assign out_any[i] = in[i] | in[i-1];
            assign out_different[i] = in[i] ^ in[i+1];
        end
    endgenerate

endmodule