module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire c_case = a | ~b;  // Simplified c=1 case from Example 1
    
    // First level: select between c=0 (a) and c=1 (a|~b) cases
    wire mux_out = c ? c_case : a;
    
    // Second level: override to 1 when a=1 (from Example 2)
    assign out = a ? 1'b1 : mux_out;
endmodule