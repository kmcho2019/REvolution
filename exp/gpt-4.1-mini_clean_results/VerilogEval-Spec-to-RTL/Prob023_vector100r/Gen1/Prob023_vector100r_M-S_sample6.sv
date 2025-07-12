module TopModule (
    input  [99:0] in,
    output [99:0] out
);
    assign out = in[0 +: 100][::-1];
endmodule