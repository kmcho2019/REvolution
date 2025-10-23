module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Direct OR implementation - more power and area efficient
    assign out = a | b | c;
endmodule