module TopModule (
    output out
);
    // Implement constant 0 using gate-level logic
    wire w1, w2;
    
    // Create two signals that will always be equal
    assign w1 = 1'b0;
    assign w2 = 1'b0;
    
    // XOR of two identical signals produces 0
    xor(out, w1, w2);
endmodule