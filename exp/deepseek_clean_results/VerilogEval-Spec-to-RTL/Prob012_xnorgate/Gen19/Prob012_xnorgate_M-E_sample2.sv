module TopModule (
    input a,
    input b,
    output out
);
    // XNOR implementation using majority voting logic
    // XNOR(a,b) = MAJ(a,b,1)
    assign out = (a & b) | (a & 1'b1) | (b & 1'b1);
endmodule