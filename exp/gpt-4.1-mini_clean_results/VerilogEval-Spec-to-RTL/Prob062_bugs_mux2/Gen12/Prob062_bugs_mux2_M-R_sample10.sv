module TopModule (
    input  wire       sel,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire       out
);
    // Select bit 0 of a or b based on sel
    assign out = sel ? b[0] : a[0];
endmodule