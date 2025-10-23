module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire [2:0] sum;
    // Sum bits to count number of '1's in input (0 to 3)
    assign sum = in[0] + in[1] + in[2];

    // Assign sum bits explicitly to output
    assign out = sum[1:0];

endmodule