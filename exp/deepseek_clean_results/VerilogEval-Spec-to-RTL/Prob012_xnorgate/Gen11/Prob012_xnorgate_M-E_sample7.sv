module TopModule (
    input a,
    input b,
    output out
);
    // Implement XNOR as equality comparison
    assign out = (a == b);
endmodule