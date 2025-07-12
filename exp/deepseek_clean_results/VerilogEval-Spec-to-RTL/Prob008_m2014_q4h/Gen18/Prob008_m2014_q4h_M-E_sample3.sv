module TopModule (
    input in,
    output out
);
    // Transmission gate implementation using Verilog primitives
    wire ctrl_n;
    
    // Inverted control for PMOS
    not (ctrl_n, 1'b1);  // Always enabled
    
    // Transmission gate: NMOS + PMOS in parallel
    nmos n1(out, in, 1'b1);  // Always enabled NMOS
    pmos p1(out, in, ctrl_n); // Always enabled PMOS
endmodule