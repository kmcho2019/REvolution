module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;
    
    assign a1_out = (x ^ y) & x;
    assign a2_out = (x ^ y) & x;
    assign b1_out = (x == y);
    assign b2_out = (x == y);
    
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;
    assign z = or_out ^ and_out;
endmodule