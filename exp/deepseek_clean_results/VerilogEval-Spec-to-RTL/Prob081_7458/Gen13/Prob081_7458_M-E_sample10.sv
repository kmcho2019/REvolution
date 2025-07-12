module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // Parameterized AND gate module
    module AND_GATE #(parameter WIDTH = 2) (
        input [WIDTH-1:0] in,
        output out
    );
        assign out = &in;
    endmodule
    
    // OR gate module
    module OR_GATE #(parameter WIDTH = 2) (
        input [WIDTH-1:0] in,
        output out
    );
        assign out = |in;
    endmodule
    
    // Wires for intermediate connections
    wire p1_and1_out, p1_and2_out;
    wire p2_and1_out, p2_and2_out;
    wire [1:0] p1_or_in, p2_or_in;
    
    // Instantiate 3-input AND gates for p1y path
    AND_GATE #(3) p1_and1 (
        .in({p1a, p1b, p1c}),
        .out(p1_and1_out)
    );
    
    AND_GATE #(3) p1_and2 (
        .in({p1d, p1e, p1f}),
        .out(p1_and2_out)
    );
    
    // Instantiate 2-input AND gates for p2y path
    AND_GATE #(2) p2_and1 (
        .in({p2a, p2b}),
        .out(p2_and1_out)
    );
    
    AND_GATE #(2) p2_and2 (
        .in({p2c, p2d}),
        .out(p2_and2_out)
    );
    
    // Connect OR gate inputs
    assign p1_or_in = {p1_and1_out, p1_and2_out};
    assign p2_or_in = {p2_and1_out, p2_and2_out};
    
    // Instantiate OR gates
    OR_GATE #(2) p1_or (
        .in(p1_or_in),
        .out(p1y)
    );
    
    OR_GATE #(2) p2_or (
        .in(p2_or_in),
        .out(p2y)
    );
endmodule