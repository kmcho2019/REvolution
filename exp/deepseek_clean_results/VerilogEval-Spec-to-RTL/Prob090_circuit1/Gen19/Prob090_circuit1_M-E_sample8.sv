module TopModule (
    input  a,
    input  b,
    output q
);
    // MUX-based AND implementation
    assign q = b ? a : 1'b0;
endmodule