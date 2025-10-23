module TopModule (
    input  wire       sel,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire       out
);
    // Output one bit from the selected 8-bit input based on sel
    assign out = sel ? b[0] : a[0];
endmodule