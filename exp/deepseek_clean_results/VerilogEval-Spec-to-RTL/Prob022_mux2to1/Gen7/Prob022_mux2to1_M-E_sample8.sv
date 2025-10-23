module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire out_a, out_b;
    
    // Tri-state buffer for input a (active when sel=0)
    assign out_a = ~sel ? a : 1'bz;
    
    // Tri-state buffer for input b (active when sel=1)
    assign out_b = sel ? b : 1'bz;
    
    // Wired-OR connection of both buffers
    assign out = out_a | out_b;
endmodule