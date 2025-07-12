module TopModule (
    input in,
    output out
);
    // Transmission gate based NOT implementation
    wire in_n = ~in;
    wire dynamic_node;
    
    // PMOS pass gate (active when in=0)
    tranif0 pmos_pass(dynamic_node, 1'b1, in);
    
    // NMOS pass gate (active when in=1)
    tranif1 nmos_pass(dynamic_node, 1'b0, in);
    
    // Weak keeper to maintain state
    pullup (weak1) p1(dynamic_node);
    pulldown (weak0) p2(dynamic_node);
    
    // Output buffer
    bufif1 out_buf(out, dynamic_node, 1'b1);
endmodule