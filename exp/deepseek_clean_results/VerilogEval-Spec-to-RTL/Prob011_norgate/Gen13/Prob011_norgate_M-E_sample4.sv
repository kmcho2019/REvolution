module TopModule (
    input  a,
    input  b,
    output out
);
    // Transmission gate based NOR implementation
    wire a_n = ~a;
    wire b_n = ~b;
    
    // Pull-up network (PMOS-like behavior)
    wire pull_up = a_n & b_n;
    
    // Pull-down network (NMOS-like behavior)
    wire pull_down = a | b;
    
    // Output stage with complementary drivers
    assign out = pull_up ? 1'b1 : (pull_down ? 1'b0 : 1'bz);
endmodule