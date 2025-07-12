module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Population count: sum of '1's in the 3-bit input
    wire [1:0] pop_count = in[0] + in[1] + in[2];
    assign out = pop_count;

endmodule