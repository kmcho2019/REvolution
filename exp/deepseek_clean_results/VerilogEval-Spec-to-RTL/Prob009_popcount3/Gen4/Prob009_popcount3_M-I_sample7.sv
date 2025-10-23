module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Population count (number of 1's) for 3-bit input
    // Optimal implementation using direct bit summation
    assign out = in[0] + in[1] + in[2];

endmodule