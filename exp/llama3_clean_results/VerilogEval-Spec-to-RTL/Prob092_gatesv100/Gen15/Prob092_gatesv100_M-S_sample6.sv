module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    reg [99:0] in_shift_left, in_shift_right;

    assign in_shift_left = {in[98:0], 1'b0}; // Shift left by one bit and fill the rightmost bit with 0
    assign in_shift_right = {1'b0, in[99:1]}; // Shift right by one bit and fill the leftmost bit with 0

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin
            assign out_both[i] = in[i] & in_shift_left[i];
            assign out_any[i] = in[i] | in_shift_right[i];
            assign out_different[i] = in[i] ^ in_shift_right[i];
        end
    endgenerate

endmodule