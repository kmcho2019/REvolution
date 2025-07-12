module TopModule(
    input [7:0] in,
    output [31:0] out
);

// The TopModule sign-extends an 8-bit input to a 32-bit output by replicating the most significant bit (MSB) 24 times and then concatenating it with the original 8-bit input.
assign out = { {24{in[7]}}, in };

endmodule