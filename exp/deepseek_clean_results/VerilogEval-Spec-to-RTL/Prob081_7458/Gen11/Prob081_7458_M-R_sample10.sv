module TopModule (
    // First OR gate inputs (two 3-input ANDs)
    input p1a, p1b, p1c,  // First 3-input AND
    input p1d, p1e, p1f,  // Second 3-input AND
    // Second OR gate inputs (two 2-input ANDs)
    input p2a, p2b,       // First 2-input AND
    input p2c, p2d,       // Second 2-input AND
    output p1y, p2y
);
    // Intermediate wires for AND gate outputs
    wire and3_1_out, and3_2_out;  // 3-input AND outputs
    wire and2_1_out, and2_2_out;  // 2-input AND outputs
    
    // First group: 3-input AND gates
    assign and3_1_out = p1a & p1b & p1c;
    assign and3_2_out = p1d & p1e & p1f;
    
    // Second group: 2-input AND gates
    assign and2_1_out = p2a & p2b;
    assign and2_2_out = p2c & p2d;
    
    // OR gate outputs
    assign p1y = and3_1_out | and3_2_out;
    assign p2y = and2_1_out | and2_2_out;
endmodule