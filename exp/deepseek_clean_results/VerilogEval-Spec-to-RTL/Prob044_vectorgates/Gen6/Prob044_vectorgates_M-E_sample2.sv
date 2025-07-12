module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    
    // Bit-sliced processing for bitwise OR and NOT operations
    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : bit_slice
            // Bitwise OR processing
            assign out_or_bitwise[i] = a[i] | b[i];
            
            // NOT operations (b in upper bits, a in lower)
            assign out_not[i] = ~a[i];      // Lower bits [2:0]
            assign out_not[i+3] = ~b[i];    // Upper bits [5:3]
        end
    endgenerate
    
    // Logical OR computed from bitwise OR result
    assign out_or_logical = |out_or_bitwise;

endmodule