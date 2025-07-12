module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Bit-slice processing for each bit position
    genvar i;
    wire [2:0] or_results;
    wire [2:0] a_not, b_not;
    
    generate
        for (i = 0; i < 3; i = i + 1) begin : bit_slice
            // Bitwise OR processing
            assign or_results[i] = a[i] | b[i];
            
            // NOT operations
            assign a_not[i] = ~a[i];
            assign b_not[i] = ~b[i];
        end
    endgenerate

    // Output assignments
    assign out_or_bitwise = or_results;
    assign out_or_logical = |or_results;  // Logical OR from bitwise results
    assign out_not = {b_not, a_not};      // Proper bit ordering

endmodule