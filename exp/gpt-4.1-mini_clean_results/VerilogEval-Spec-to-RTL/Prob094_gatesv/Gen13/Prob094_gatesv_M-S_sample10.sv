module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    assign out_both      = (in & (in << 1)) & 4'b1110;     // last bit zeroed as no neighbor
    assign out_any       = (in | (in >> 1)) & 4'b1110;     // first bit zeroed as no neighbor to right
    assign out_different = in ^ {in[2:0], in[3]};          // rotate left by 1 bit for wrap-around

endmodule