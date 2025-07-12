// Module for 3-input AND gate
module AND3(
    input a,
    input b,
    input c,
    output y
);
    assign y = a & b & c;
endmodule

// Module for 2-input AND gate
module AND2(
    input a,
    input b,
    output y
);
    assign y = a & b;
endmodule

// Module for 2-input OR gate
module OR2(
    input a,
    input b,
    output y
);
    assign y = a | b;
endmodule

// TopModule with optimized design
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
    // Directly compute outputs without intermediate wires
    // to potentially reduce area and power
    AND3 and1(p1a, p1b, p1c, p1y);
    AND3 and2(p1d, p1e, p1f, p1y);
    AND2 and3(p2a, p2b, p2y);
    AND2 and4(p2c, p2d, p2y);
    
    // Use assign statements for OR operations to maintain clarity
    // and potentially allow synthesis tools to optimize further
    assign p1y = and1.y | and2.y;
    assign p2y = and3.y | and4.y;
endmodule