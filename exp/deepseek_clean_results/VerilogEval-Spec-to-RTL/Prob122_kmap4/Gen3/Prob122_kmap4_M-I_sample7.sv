module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Optimal implementation - cannot be improved at RTL level
    assign out = (a ^ b) ^ (c ^ d);
endmodule