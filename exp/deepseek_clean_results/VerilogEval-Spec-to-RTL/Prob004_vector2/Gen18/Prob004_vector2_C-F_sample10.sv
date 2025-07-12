module ByteReverser (
    input  [31:0] in,
    output [31:0] out
);
    // Optimal direct concatenation for 32-bit byte reversal
    assign out = {in[7:0],   in[15:8], 
                  in[23:16], in[31:24]};
endmodule

module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    ByteReverser reverser (
        .in(in),
        .out(out)
    );
endmodule