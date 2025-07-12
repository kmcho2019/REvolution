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

    // Use assign statements for AND operations
    wire and1, and2, and3_out, and4_out;
    assign and1 = p1a & p1b & p1c;
    assign and2 = p1d & p1e & p1f;
    assign and3_out = p2a & p2b;
    assign and4_out = p2c & p2d;

    // Instantiate OR gates
    or2 or_gate1(and1, and2, p1y);
    or2 or_gate2(and3_out, and4_out, p2y);

endmodule