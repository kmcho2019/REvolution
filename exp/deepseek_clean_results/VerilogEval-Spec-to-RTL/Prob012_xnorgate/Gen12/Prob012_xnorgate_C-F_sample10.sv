module TopModule (
    input a,
    input b,
    output out
);
    // Optimal XNOR implementation combining clarity and direct logic
    assign out = ~(a ^ b);
endmodule