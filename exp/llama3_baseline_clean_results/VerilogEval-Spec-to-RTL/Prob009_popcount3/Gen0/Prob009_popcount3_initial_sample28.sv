module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // population count
    assign out = (in[0] + in[1] + in[2]);

    // note that the above line is not synthesizable in most tools
    // because it performs an arithmetic operation on a non-numeric type.
    // The synthesizable version would be:

    assign out[0] = in[0] | in[1] | in[2];
    assign out[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]);

    // or if we want the exact population count:
    assign out = in[0] + in[1] + in[2];

    // A more correct way of writing the above would be:
    wire [1:0] count;
    assign count = (in[0] == 1'b1) + (in[1] == 1'b1) + (in[2] == 1'b1);
    assign out = count;

endmodule