module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Directly count the number of '1's in the 255-bit input vector
    assign out = $countones(in);

endmodule