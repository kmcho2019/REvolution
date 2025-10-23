module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    // Bit-reversed mapping using generate loop
    // Equivalent to: assign out = {in[0], in[1], ..., in[99]};
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : bit_reverse
            assign out[i] = in[99-i];
        end
    endgenerate

endmodule