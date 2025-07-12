module TopModule (
    input in,
    output out
);
    // Transmission gate implementation
    wire tg_enable = 1'b1;  // Always enabled for continuous assignment
    wire out_n, out_p;
    
    // NMOS pass transistor
    assign out_n = tg_enable ? in : 1'bz;
    
    // PMOS pass transistor
    assign out_p = ~tg_enable ? in : 1'bz;
    
    // Combine the outputs
    assign out = (out_n === 1'bz) ? out_p : out_n;
endmodule