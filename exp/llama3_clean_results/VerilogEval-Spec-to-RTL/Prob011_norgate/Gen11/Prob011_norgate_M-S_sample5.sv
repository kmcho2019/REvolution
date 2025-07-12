// Simplified module implementing a NOR gate.
module TopModule(
    input  a,  
    input  b,  
    output out  
);

// Direct NOR implementation.
assign out = ~(a | b);

endmodule