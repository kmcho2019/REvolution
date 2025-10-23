module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // Intermediate wires for AND gate outputs
    wire p1_and1, p1_and2;  // For p1y's AND terms
    wire p2_and1, p2_and2;  // For p2y's AND terms
    
    // First 3-input AND for p1y (p1a & p1b & p1c)
    assign p1_and1 = p1a & p1b & p1c;
    
    // Second 3-input AND for p1y (p1d & p1e & p1f)
    assign p1_and2 = p1d & p1e & p1f;
    
    // First 2-input AND for p2y (p2a & p2b)
    assign p2_and1 = p2a & p2b;
    
    // Second 2-input AND for p2y (p2c & p2d)
    assign p2_and2 = p2c & p2d;
    
    // OR operations for final outputs
    assign p1y = p1_and1 | p1_and2;
    assign p2y = p2_and1 | p2_and2;
endmodule