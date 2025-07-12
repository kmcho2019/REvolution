module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);

assign out = in[0 +: 100] ^ 0; // dummy to show the idea but incorrect

endmodule