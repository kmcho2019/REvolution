module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    wire [1:0] sum_lower;
    wire [1:0] sum_all;

    // Sum the first two bits
    assign sum_lower = in[0] + in[1];
    // Add the third bit
    assign sum_all = sum_lower + in[2];

    assign out = sum_all;
endmodule