module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Assign the lower 8 bits of the output directly from the input
    assign out[7:0] = in;

    // Conditionally assign the upper 24 bits based on the MSB of the input
    assign out[31:8] = (in[7] == 1) ? 24'd-1 : 24'd0;

endmodule