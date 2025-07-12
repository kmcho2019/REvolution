module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Handle edge cases explicitly and set unused bits
    assign out_both[99] = 1'b0;
    assign out_any[0] = 1'b0;

    // Combined generate block for both and any outputs
    genvar i;
    generate
        for (i = 0; i < 99; i = i + 1) begin : combined_gen
            assign out_both[i] = in[i] & in[i+1];
            if (i > 0) assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate

    // Wrap-around difference remains optimal
    assign out_different = in ^ {in[0], in[99:1]};

    // Ensure remaining bits are explicitly set
    assign out_any[99] = in[99] | in[98];  // Complete the last any bit

endmodule