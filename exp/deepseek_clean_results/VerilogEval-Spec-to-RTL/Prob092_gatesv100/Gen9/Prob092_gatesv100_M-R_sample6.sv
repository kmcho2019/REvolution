module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Handle edge cases explicitly
    assign out_both[99] = 1'b0;
    assign out_any[0] = 1'b0;

    // Generate blocks for the regular bits
    genvar i;
    generate
        for (i = 0; i < 99; i = i + 1) begin : both_gen
            assign out_both[i] = in[i] & in[i+1];
        end
        for (i = 1; i < 100; i = i + 1) begin : any_gen
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate

    // Wrap-around difference remains the same
    assign out_different = in ^ {in[0], in[99:1]};

endmodule