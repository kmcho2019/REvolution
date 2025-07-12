module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Assign the sign-extended input to the output
    assign out = { {24{in[7]}}, in };

endmodule