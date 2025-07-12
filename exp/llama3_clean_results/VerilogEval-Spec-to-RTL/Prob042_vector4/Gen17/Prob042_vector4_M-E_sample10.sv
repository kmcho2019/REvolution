module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Determine the pattern to fill the upper bits based on the MSB of the input
    wire [23:0] fill_pattern = (in[7] == 1'b1) ? 24'hFFFFFF : 24'h0;

    // Concatenate the fill pattern with the input to achieve sign extension
    assign out = {fill_pattern, in};

endmodule