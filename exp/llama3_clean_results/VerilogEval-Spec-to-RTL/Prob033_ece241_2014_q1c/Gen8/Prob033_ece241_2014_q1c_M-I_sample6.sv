module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    // Perform 8-bit addition
    wire [8:0] sum;
    assign sum = {1'b0, a} + {1'b0, b};

    // Assign the result
    assign s = sum[7:0];

    // Detect overflow
    assign overflow = sum[8] & (a[7] == b[7]);

endmodule