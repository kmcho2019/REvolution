module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire at_least_one;
    wire at_least_two;

    assign at_least_one = in[0] | in[1] | in[2];
    assign at_least_two = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]);

    assign out[0] = at_least_one;
    assign out[1] = at_least_two;

endmodule