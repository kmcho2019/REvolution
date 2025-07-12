module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Temporary wire for left-shifted version of input (wrap-around)
    wire [99:0] in_left_shifted = {in[0], in[99:1]};

    // Generate blocks for each output
    genvar i;
    
    // out_both generation
    generate
        assign out_both[99] = 1'b0;  // Edge case
        for (i = 0; i < 99; i = i + 1) begin : both_gen
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate

    // out_any generation
    generate
        assign out_any[0] = 1'b0;  // Edge case
        for (i = 1; i < 100; i = i + 1) begin : any_gen
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate

    // out_different generation
    generate
        for (i = 0; i < 100; i = i + 1) begin : diff_gen
            assign out_different[i] = in[i] ^ in_left_shifted[i];
        end
    endgenerate

endmodule