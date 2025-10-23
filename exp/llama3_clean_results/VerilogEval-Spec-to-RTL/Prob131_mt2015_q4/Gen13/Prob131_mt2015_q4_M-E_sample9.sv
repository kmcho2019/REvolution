module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1_out, b1_out, a2_out, b2_out, or_out, and_out;
    
    // Directly computing the outputs of Module A and Module B based on x and y
    assign a1_out = x & (x ^ y);
    assign b1_out = (x == y);
    assign a2_out = x & (x ^ y);
    assign b2_out = (x == y);
    
    // Computing the OR and AND outputs
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;
    
    // Final output logic
    assign z = or_out ^ and_out;
endmodule