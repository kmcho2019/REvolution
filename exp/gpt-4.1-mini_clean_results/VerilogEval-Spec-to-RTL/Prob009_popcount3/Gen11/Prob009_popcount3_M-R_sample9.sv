module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Sum the individual bits to produce the population count (0 to 3)
    // Verilog interprets bits as numbers, so sum is in the range [0..3].
    assign out = in[0] + in[1] + in[2];

endmodule