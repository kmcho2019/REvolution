module TopModule (
    input a,
    input b,
    output out
);
    // Direct XNOR implementation using gate-level logic
    assign out = ~(a ^ b);
endmodule