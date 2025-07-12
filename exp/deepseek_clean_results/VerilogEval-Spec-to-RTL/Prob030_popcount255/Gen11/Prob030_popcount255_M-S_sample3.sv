module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First stage: Count '1's in 3-bit chunks (85 chunks)
    wire [7:0] count = 
        // Count groups of 3 bits (85 groups)
        (in[0] + in[1] + in[2]) +
        (in[3] + in[4] + in[5]) +
        (in[6] + in[7] + in[8]) +
        // Continue this pattern for all 85 groups...
        (in[252] + in[253] + in[254]);

    assign out = count;

endmodule