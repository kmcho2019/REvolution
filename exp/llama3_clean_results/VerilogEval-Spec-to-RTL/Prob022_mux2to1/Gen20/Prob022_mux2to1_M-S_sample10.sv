// Module declaration for a 2-to-1 multiplexer
module TopModule(
    input  a,  
    input  b,  
    input  sel, 
    output out  
);

// Implement the multiplexer logic
assign out = (sel) ? b : a;

endmodule