module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Compare if {b,c} >= 2'b01 (i.e., if either b or c is 1)
    assign q = (b | c) ? 1'b1 : 1'b0;
endmodule