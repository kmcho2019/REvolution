// Module for a generic N-input AND gate
module and_n(
    input [7:0] inputs,  // 8 inputs maximum
    output y
);
    assign y = &inputs;  // bitwise AND operation
endmodule

// Module for a generic 2-input OR gate
module or2(
    input a,
    input b,
    output y
);
    assign y = a | b;  // logical OR operation
endmodule

// TopModule implementing the 7458 chip functionality
module TopModule(
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p1e,
    input p1f,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);
    // Instantiate AND gates and OR gates directly
    wire and1, and2, and3, and4;
    and_n and_gate1({p1a, p1b, p1c, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}, and1);
    and_n and_gate2({p1d, p1e, p1f, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}, and2);
    and_n and_gate3({p2a, p2b, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}, and3);
    and_n and_gate4({p2c, p2d, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}, and4);

    or2 or_gate1(and1, and2, p1y);
    or2 or_gate2(and3, and4, p2y);
endmodule