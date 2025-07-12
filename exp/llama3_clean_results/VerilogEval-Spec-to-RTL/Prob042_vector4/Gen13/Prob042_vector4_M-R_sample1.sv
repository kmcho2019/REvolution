module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Replicate the sign bit (MSB) of the input and concatenate it with the input
    assign out = {24{in[7]}, in};

endmodule