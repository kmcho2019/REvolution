module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Directly assign XNOR output using built-in operator
    assign out = ~(a ^ b);
endmodule