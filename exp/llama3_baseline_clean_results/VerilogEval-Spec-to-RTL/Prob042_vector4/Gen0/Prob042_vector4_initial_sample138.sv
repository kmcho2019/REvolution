module TopModule(
    input [7:0] in,  // 8-bit input
    output [31:0] out  // 32-bit output
);

    // Replicate the sign bit (in[7]) 24 times and concatenate it with the original 8-bit number
    assign out = { {24{in[7]}}, in };

endmodule