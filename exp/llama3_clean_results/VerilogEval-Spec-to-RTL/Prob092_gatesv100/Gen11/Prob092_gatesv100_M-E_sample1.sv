module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Shift register for out_both
    wire [99:0] in_shifted_right;
    assign in_shifted_right[99] = 1'b0; // out_both[99] is always 0
    assign in_shifted_right[0] = in[99]; // wrap-around
    assign out_both[99] = 1'b0; // out_both[99] is always 0
    genvar i;
    generate
        for (i = 1; i < 100; i = i + 1) begin
            assign in_shifted_right[i] = in[i-1];
            assign out_both[i-1] = in[i] & in_shifted_right[i];
        end
    endgenerate

    // Shift register for out_any
    wire [99:0] in_shifted_left;
    assign in_shifted_left[0] = 1'b0; // out_any[0] is always 0
    assign in_shifted_left[99] = in[0]; // out_any[99] needs in[0]
    assign out_any[0] = 1'b0; // out_any[0] is always 0
    generate
        for (i = 0; i < 99; i = i + 1) begin
            assign in_shifted_left[i] = in[i+1];
            assign out_any[i+1] = in[i] | in_shifted_left[i];
        end
    endgenerate

    // Shift register for out_different
    wire [99:0] in_shifted_right_different;
    assign in_shifted_right_different[99] = in[0]; // wrap-around
    assign out_different[99] = in[99] ^ in_shifted_right_different[99];
    generate
        for (i = 0; i < 99; i = i + 1) begin
            assign in_shifted_right_different[i] = in[i+1];
            assign out_different[i] = in[i] ^ in_shifted_right_different[i];
        end
    endgenerate

endmodule