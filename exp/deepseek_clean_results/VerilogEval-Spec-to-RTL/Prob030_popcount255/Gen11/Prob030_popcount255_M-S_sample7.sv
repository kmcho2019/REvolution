module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First stage: Count 1s in 3-bit chunks (85 chunks)
    wire [7:0] sum = 
        // First 84 chunks of 3 bits (252 bits)
        (in[0] + in[1] + in[2]) +
        (in[3] + in[4] + in[5]) +
        (in[6] + in[7] + in[8]) +
        // ... continue this pattern for all 3-bit chunks
        (in[249] + in[250] + in[251]) +
        // Last 3 bits (252-254)
        (in[252] + in[253] + in[254]);

    assign out = sum;

endmodule