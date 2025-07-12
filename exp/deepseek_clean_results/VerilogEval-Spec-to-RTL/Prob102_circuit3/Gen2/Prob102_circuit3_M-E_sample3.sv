module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Use a and b as select lines
    // Data inputs are controlled by c and d
    assign q = (a | b) ? (c | d) : 1'b0;
endmodule