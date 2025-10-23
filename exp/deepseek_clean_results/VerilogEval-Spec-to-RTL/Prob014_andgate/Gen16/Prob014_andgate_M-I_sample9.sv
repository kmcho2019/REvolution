module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Optimal AND gate implementation
    assign out = a & b;
endmodule