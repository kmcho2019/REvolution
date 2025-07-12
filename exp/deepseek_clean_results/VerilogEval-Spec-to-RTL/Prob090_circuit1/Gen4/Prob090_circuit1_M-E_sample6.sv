module TopModule (
    input a,
    input b,
    output q
);
    assign q = b ? a : 1'b0;
endmodule