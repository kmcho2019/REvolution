module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Parameterized group size (10 bits per group)
    localparam GROUP_SIZE = 10;
    localparam NUM_GROUPS = 100/GROUP_SIZE;
    
    // Direct bitwise selection with concatenation
    assign out = sel ? b : a;

endmodule