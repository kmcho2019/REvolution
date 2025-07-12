module TopModule(
    input  [7:0] in,
    output [7:0] out
);
    // Direct assignment with bit reversal
    assign out = in[7:0];
endmodule