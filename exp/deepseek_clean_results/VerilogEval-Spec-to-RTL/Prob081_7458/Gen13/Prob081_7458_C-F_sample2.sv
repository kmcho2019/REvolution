module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // Intermediate signals for AND outputs
    wire p1_and1_out = p1a & p1b & p1c;  // First 3-input AND for p1y
    wire p1_and2_out = p1d & p1e & p1f;  // Second 3-input AND for p1y
    wire p2_and1_out = p2a & p2b;        // First 2-input AND for p2y
    wire p2_and2_out = p2c & p2d;        // Second 2-input AND for p2y

    // OR operations
    assign p1y = p1_and1_out | p1_and2_out;
    assign p2y = p2_and1_out | p2_and2_out;
endmodule