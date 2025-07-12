module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    wire [1:0] sum_bits;
    
    // Explicitly sum the individual bits of 'in'
    assign sum_bits = in[0] + in[1] + in[2];
    assign out = sum_bits;

endmodule