module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Population count with explicit adder structure
    wire [1:0] partial_sum;
    
    // First add bits 0 and 1
    assign partial_sum = in[0] + in[1];
    
    // Then add bit 2
    assign out = partial_sum + in[2];

endmodule