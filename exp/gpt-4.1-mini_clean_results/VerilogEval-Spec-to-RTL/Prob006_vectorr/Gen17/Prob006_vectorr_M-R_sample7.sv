module TopModule (
    input  wire [7:0] in,
    output wire [7:0] out
);

    // Assign output by concatenating bits of input in reverse order
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule