module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Efficient population count for 3 bits:
    // Sum all bits using 2-bit additions
    assign out = in[0] + in[1] + in[2];

endmodule