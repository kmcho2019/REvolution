`default_nettype none

module NAND #(parameter WIDTH = 4) (
    input [WIDTH-1:0] in,
    output out
);
    // 4-input NAND implementation using reduction operator
    // Equivalent to 7420 chip's NAND gate functionality
    assign out = ~&in;
endmodule

module TopModule (
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

    // Buffer inputs to reduce capacitance effects
    wire p1a_buf, p1b_buf, p1c_buf, p1d_buf;
    wire p2a_buf, p2b_buf, p2c_buf, p2d_buf;
    
    assign p1a_buf = p1a;
    assign p1b_buf = p1b;
    assign p1c_buf = p1c;
    assign p1d_buf = p1d;
    assign p2a_buf = p2a;
    assign p2b_buf = p2b;
    assign p2c_buf = p2c;
    assign p2d_buf = p2d;

    // First 4-input NAND gate (first gate in 7420)
    NAND #(.WIDTH(4)) gate1 (
        .in({p1a_buf, p1b_buf, p1c_buf, p1d_buf}),
        .out(p1y)
    );

    // Second 4-input NAND gate (second gate in 7420)
    NAND #(.WIDTH(4)) gate2 (
        .in({p2a_buf, p2b_buf, p2c_buf, p2d_buf}),
        .out(p2y)
    );

endmodule