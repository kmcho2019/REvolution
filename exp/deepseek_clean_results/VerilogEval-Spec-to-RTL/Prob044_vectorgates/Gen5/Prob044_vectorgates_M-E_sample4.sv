module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    
    // Bit-sliced OR computation
    wire [2:0] or_bits;
    assign or_bits[0] = a[0] | b[0];
    assign or_bits[1] = a[1] | b[1];
    assign or_bits[2] = a[2] | b[2];
    
    // Shared logic for both OR outputs
    assign out_or_bitwise = or_bits;
    assign out_or_logical = |or_bits;
    
    // Optimized NOT operations with direct concatenation
    assign out_not = {~b, ~a};

endmodule