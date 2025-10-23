module TopModule (
    input [2:0] in,       // 3-bit input vector
    output [1:0] out      // Population count (0-3)
);
    // Count number of '1's in input using arithmetic sum
    assign out = in[0] + in[1] + in[2];
endmodule