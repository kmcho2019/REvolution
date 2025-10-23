module TopModule(
    input  a,  
    input  b,  
    output q   
);
// Using a single line assign statement for simplicity and clarity
assign q = a & b;

// Alternatively, using a continuous assignment for clarity
// assign q = ~(~a & ~b); // Using NAND logic with inversion

endmodule