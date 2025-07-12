module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    assign out = ~(a ^ b); // Implement XNOR using continuous assignment
endmodule