module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire [1:0] sum;  // 2 bits are sufficient to count up to 3

    assign sum = in[0] + in[1] + in[2];
    assign out = sum;

endmodule