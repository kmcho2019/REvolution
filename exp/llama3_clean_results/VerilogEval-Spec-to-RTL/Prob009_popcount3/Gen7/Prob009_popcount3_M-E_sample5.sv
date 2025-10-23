module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Internal wires
    wire [1:0] count_and;
    wire [1:0] count_or;

    // Bitwise operations to isolate and count bits
    assign count_and = {in[1] & in[2], in[0] & (in[1] | in[2])};
    assign count_or = {in[1] | in[2], in[0]};

    // Adder to sum the results of bitwise operations
    assign out = count_and + count_or;

endmodule