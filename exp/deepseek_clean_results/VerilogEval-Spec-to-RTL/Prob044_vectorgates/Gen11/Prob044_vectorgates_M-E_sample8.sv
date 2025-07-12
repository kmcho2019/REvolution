module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Bit-sliced inverted storage
    wire [2:0] not_a;
    wire [2:0] not_b;
    
    // Generate inverted values first
    assign not_a = ~a;
    assign not_b = ~b;
    
    // Bit-sliced OR processing
    assign out_or_bitwise[0] = a[0] | b[0];
    assign out_or_bitwise[1] = a[1] | b[1];
    assign out_or_bitwise[2] = a[2] | b[2];
    
    // Dynamic strength reduction for logical OR
    wire a_all_ones = &a;
    wire b_all_ones = &b;
    
    // Multiplexer-based logical OR
    assign out_or_logical = a_all_ones ? 1'b1 :
                           b_all_ones ? 1'b1 :
                           |out_or_bitwise;
    
    // Bit-interleaved NOT outputs
    assign out_not = {not_b[2], not_a[2], 
                     not_b[1], not_a[1], 
                     not_b[0], not_a[0]};
    
endmodule