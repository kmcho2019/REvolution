module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    // Sum the three input bits using addition operator
    // The result is a 2-bit number representing the population count
    assign out = in[0] + in[1] + in[2];
endmodule