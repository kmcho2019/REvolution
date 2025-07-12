module MultiInputGate #(
    parameter INPUTS = 2
) (
    input [INPUTS-1:0] in,
    output out
);
    // Parameterized AND gate implementation
    assign out = &in;
endmodule

module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // Intermediate AND outputs
    wire [1:0] p1_and_out;
    wire [1:0] p2_and_out;

    // Instantiate 3-input AND gates for p1y
    MultiInputGate #(.INPUTS(3)) p1_and1 (
        .in({p1a, p1b, p1c}),
        .out(p1_and_out[0])
    );
    
    MultiInputGate #(.INPUTS(3)) p1_and2 (
        .in({p1d, p1e, p1f}),
        .out(p1_and_out[1])
    );

    // Instantiate 2-input AND gates for p2y
    MultiInputGate #(.INPUTS(2)) p2_and1 (
        .in({p2a, p2b}),
        .out(p2_and_out[0])
    );
    
    MultiInputGate #(.INPUTS(2)) p2_and2 (
        .in({p2c, p2d}),
        .out(p2_and_out[1])
    );

    // OR operations using bitwise OR on concatenated outputs
    assign p1y = |p1_and_out;
    assign p2y = |p2_and_out;
endmodule