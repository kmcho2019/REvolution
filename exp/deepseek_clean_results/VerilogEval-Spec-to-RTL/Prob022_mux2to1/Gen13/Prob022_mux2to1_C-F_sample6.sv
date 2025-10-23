// Optimal 2-to-1 Multiplexer
module TopModule (
    input  a,    // First input
    input  b,    // Second input
    input  sel,  // Selection signal
    output out  // Multiplexer output
);
    // Select 'a' when sel=0, 'b' when sel=1
    assign out = sel ? b : a;
endmodule