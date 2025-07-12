module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Directly replicate the MSB of the input 24 times and concatenate it with the input
    assign out = { {24{in[7]}}, in };

endmodule