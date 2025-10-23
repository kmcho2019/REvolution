module TopModule (
    input a,
    input b,
    output q
);
    // Implement AND using a MUX
    assign q = (a & b) ? 1'b1 : 1'b0;
endmodule