module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // p1y logic: OR of two 3-input ANDs
    wire p1_and1 = p1a & p1b & p1c;  // First 3-input AND
    wire p1_and2 = p1d & p1e & p1f;  // Second 3-input AND
    assign p1y = p1_and1 | p1_and2;  // Final OR

    // p2y logic: OR of two 2-input ANDs
    wire p2_and1 = p2a & p2b;        // First 2-input AND
    wire p2_and2 = p2c & p2d;        // Second 2-input AND
    assign p2y = p2_and1 | p2_and2;  // Final OR

endmodule