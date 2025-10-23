module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Replicate the MSB 24 times and append the original 8-bit number
    assign out = {24{in[7]}, in};

endmodule