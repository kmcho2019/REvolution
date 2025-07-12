module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // Intermediate wires for AND gate outputs
    wire p1_and1, p1_and2;
    wire p2_and1, p2_and2;
    
    // First OR input (3-input AND)
    assign p1_and1 = p1a & p1b & p1c;
    // Second OR input (3-input AND)
    assign p1_and2 = p1d & p1e & p1f;
    // OR gate for p1y
    assign p1y = p1_and1 | p1_and2;
    
    // First OR input (2-input AND)
    assign p2_and1 = p2a & p2b;
    // Second OR input (2-input AND)
    assign p2_and2 = p2c & p2d;
    // OR gate for p2y
    assign p2y = p2_and1 | p2_and2;
endmodule