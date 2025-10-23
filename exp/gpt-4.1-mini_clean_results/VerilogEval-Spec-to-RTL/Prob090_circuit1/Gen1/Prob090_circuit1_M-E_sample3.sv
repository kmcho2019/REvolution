module TopModule (
    input a,
    input b,
    output q
);
    // MUX-based AND: q = a ? b : 0;
    assign q = a ? b : 1'b0;
endmodule