module TopModule(
    input x,
    input y,
    output z
);
    wire a_out = x & ~y;      // Module A's function
    wire b_out = ~(x ^ y);    // Module B's function
    
    wire or_out = a_out | b_out;
    wire and_out = a_out & b_out;
    
    assign z = or_out ^ and_out;
endmodule