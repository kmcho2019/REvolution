module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1], where in[99] has no neighbor -> out_both[99] = 0
    wire [99:0] shifted_left = in << 1;
    assign out_both = (in & shifted_left) & {99{1'b1}, 1'b0};

    // out_any[i] = in[i] | in[i-1], where in[0] has no neighbor -> out_any[0] = 0
    wire [99:0] shifted_right = in >> 1;
    assign out_any = (in | shifted_right) & {1'b0, 99{1'b1}};

    // out_different[i] = in[i] ^ in[(i+1) mod 100], wrap-around implemented by rotating right by 1
    assign out_different = in ^ {in[0], in[99:1]};

endmodule