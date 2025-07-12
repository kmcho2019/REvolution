module TopModule(
    input  a,
    input  b,
    output out
);
    
// Implementing a 2-input AND gate using a continuous assignment
assign out = a & b;

endmodule