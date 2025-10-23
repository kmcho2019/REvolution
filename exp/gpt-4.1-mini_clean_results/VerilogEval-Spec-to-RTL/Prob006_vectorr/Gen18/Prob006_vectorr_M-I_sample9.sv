module TopModule (
    input  wire [7:0] in,
    output wire [7:0] out
);
    // Concatenate input bits in reverse order directly in continuous assignment
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
endmodule