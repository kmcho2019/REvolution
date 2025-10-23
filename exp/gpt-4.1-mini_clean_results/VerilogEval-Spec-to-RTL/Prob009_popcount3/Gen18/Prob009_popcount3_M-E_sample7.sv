module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire sum1, carry1;
    wire sum2, carry2;

    // Add in[0] and in[1]
    assign sum1 = in[0] ^ in[1];
    assign carry1 = in[0] & in[1];

    // Add sum1 and in[2]
    assign sum2 = sum1 ^ in[2];
    assign carry2 = sum1 & in[2];

    // Final count is carry bits plus sum2
    assign out = {carry1 | carry2, sum2};

endmodule