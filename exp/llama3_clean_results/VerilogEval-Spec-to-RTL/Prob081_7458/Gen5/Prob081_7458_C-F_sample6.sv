// Define a module for a 3-input AND gate
module and3(input a, input b, input c, output y);
    assign y = a & b & c;
endmodule

// Define a module for a 2-input AND gate
module and2(input a, input b, output y);
    assign y = a & b;
endmodule

// Define a module for a 2-input OR gate
module or2(input a, input b, output y);
    assign y = a | b;
endmodule

// Define the TopModule
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

    // Instantiate AND gates and OR gate for p1y
    wire and1, and2;
    and3 and_gate1(p1a, p1b, p1c, and1);
    and3 and_gate2(p1d, p1e, p1f, and2);
    or2 or_gate1(and1, and2, p1y);

    // Instantiate AND gates and OR gate for p2y
    wire and3, and4;
    and2 and_gate3(p2a, p2b, and3);
    and2 and_gate4(p2c, p2d, and4);
    or2 or_gate2(and3, and4, p2y);

endmodule