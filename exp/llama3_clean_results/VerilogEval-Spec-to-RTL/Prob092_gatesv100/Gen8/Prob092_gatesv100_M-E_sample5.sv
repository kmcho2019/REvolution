module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // For out_both: Shift in to the right and perform AND operation
    assign out_both = in & (in >> 1);
    // Set MSB of out_both to 0 since there's no bit to the left of MSB
    assign out_both[99] = 1'b0;

    // For out_any: Shift in to the left and perform OR operation
    assign out_any = in | (in << 1);
    // Set LSB of out_any to 0 since there's no bit to the right of LSB
    assign out_any[0] = 1'b0;

    // For out_different: Use XOR with circularly shifted in
    assign out_different = in ^ ({in[0], in[99:1]});

endmodule