module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bit-sliced processing for OR and NOT operations
    wire [2:0] or_results;
    wire [2:0] not_a;
    wire [2:0] not_b;
    
    // Process each bit in parallel
    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin: bit_slice
            assign or_results[i] = a[i] | b[i];
            assign not_a[i] = ~a[i];
            assign not_b[i] = ~b[i];
        end
    endgenerate
    
    // Output assignments
    assign out_or_bitwise = or_results;
    assign out_or_logical = |or_results;  // Reuse bitwise OR results
    assign out_not = {not_b, not_a};      // Concatenate NOT results
endmodule