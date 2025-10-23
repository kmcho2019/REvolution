module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Direct vector output and bit extraction (MSB: o2, LSB: o0)
    assign outv = vec;
    assign o2 = vec[2];  // MSB
    assign o1 = vec[1];
    assign o0 = vec[0];  // LSB

endmodule