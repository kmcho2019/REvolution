module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    // count the number of '1's in the input vector
    wire [1:0] count;
    assign count = (in[0] + in[1] + in[2]);

    // encode the count into a 2-bit binary number
    assign out = count[1:0];

endmodule