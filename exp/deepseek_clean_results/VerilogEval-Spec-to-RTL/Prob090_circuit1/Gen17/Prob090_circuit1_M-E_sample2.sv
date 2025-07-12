module TopModule (
    input a,
    input b,
    output q
);
    // Implement AND using a 2:1 MUX
    assign q = a ? b : 1'b0;
endmodule