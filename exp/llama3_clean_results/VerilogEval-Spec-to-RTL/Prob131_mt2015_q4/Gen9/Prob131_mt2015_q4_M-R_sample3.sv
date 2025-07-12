module TopModule(x, y, z);
    input x, y;
    output z;
    
    // Calculate the outputs of modules A and B directly
    wire a1_out = (x ^ y) & x;
    wire b1_out = (x == y);
    wire a2_out = (x ^ y) & x;
    wire b2_out = (x == y);
    
    // Calculate the outputs of the OR and AND gates
    wire or_out = a1_out | b1_out;
    wire and_out = a2_out & b2_out;
    
    // Apply the XOR operation to get the final output
    assign z = or_out ^ and_out;
endmodule