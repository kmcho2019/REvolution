// Module TopModule implements a NOR gate.
module TopModule(
    input  a,  
    input  b,  
    output out  
);

// Assign the NOR operation result to the output out.
assign out = ~(a | b);

endmodule