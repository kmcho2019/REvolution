module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Simple direct XNOR implementation using built-in operator
    assign out = ~(a ^ b);
endmodule