module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output wire [N-1:0] c
);

assign c = (a[N-1] == b[N-1]) ? 
            (a[N-1] ? (~a + 1) + (~b + 1) : a + b) : 
            (a[N-1] ? (~a + 1) - (b[N-1] ? (~b + 1) : b) : 
             a - (b[N-1] ? (~b + 1) : b));

endmodule