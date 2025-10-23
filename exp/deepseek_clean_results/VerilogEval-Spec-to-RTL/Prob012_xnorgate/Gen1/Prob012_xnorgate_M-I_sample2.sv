module TopModule (
    input a,
    input b,
    output out
);
    assign out = (a == b);  // Logical equality implements XNOR functionality
endmodule