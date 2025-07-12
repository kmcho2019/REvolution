module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Assign out_both[99] to 0 since it has no neighbor to the left
    assign out_both[99] = 0;

    // Assign out_any[0] to 0 since it has no neighbor to the right
    assign out_any[0] = 0;

    // Iterate over each bit of the input vector (excluding the most significant bit)
    genvar i;
    generate
        for (i = 0; i < 99; i++) begin
            // Check if the current bit and its neighbor to the left are both '1'
            assign out_both[i] = in[i] & in[i+1];

            // Check if the current bit or its neighbor to the right is '1'
            assign out_any[i+1] = in[i] | in[i+1];

            // Check if the current bit is different from its neighbor to the left (wrapping around for the most significant bit)
            assign out_different[i] = in[i] != in[i+1];
        end
    endgenerate

    // Wrap-around condition for the most significant bit
    assign out_different[99] = in[99] != in[0];

endmodule