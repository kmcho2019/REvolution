module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;

generate
    // Handle the most significant bit separately for out_both
    assign out_both[99] = 1'b0;

    // Handle the least significant bit separately for out_any
    assign out_any[0] = 1'b0;

    // Handle all other bits for out_both, out_any, and out_different
    for (i = 1; i < 100; i++) begin
        assign out_both[i-1] = in[i] & in[i-1];
        assign out_any[i] = in[i] | in[i-1];
        assign out_different[i-1] = in[i] ^ in[i-1];
    end

    // Wrap around for the most significant bit for out_different
    assign out_different[99] = in[99] ^ in[0];

endgenerate

endmodule