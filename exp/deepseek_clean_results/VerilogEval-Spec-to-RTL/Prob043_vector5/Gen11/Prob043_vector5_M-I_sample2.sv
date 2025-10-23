module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);
    // Self-comparisons (always 1)
    assign out[24] = 1'b1;  // a==a
    assign out[18] = 1'b1;  // b==b
    assign out[12] = 1'b1;  // c==c
    assign out[6]  = 1'b1;  // d==d
    assign out[0]  = 1'b1;  // e==e
    
    // Unique comparisons
    wire a_eq_b = (a == b);
    wire a_eq_c = (a == c);
    wire a_eq_d = (a == d);
    wire a_eq_e = (a == e);
    wire b_eq_c = (b == c);
    wire b_eq_d = (b == d);
    wire b_eq_e = (b == e);
    wire c_eq_d = (c == d);
    wire c_eq_e = (c == e);
    wire d_eq_e = (d == e);
    
    // Assign outputs using the precomputed comparisons
    // a comparisons
    assign out[23] = a_eq_b;  // a==b
    assign out[22] = a_eq_c;  // a==c
    assign out[21] = a_eq_d;  // a==d
    assign out[20] = a_eq_e;  // a==e
    
    // b comparisons
    assign out[19] = a_eq_b;  // b==a (same as a==b)
    assign out[17] = b_eq_c;  // b==c
    assign out[16] = b_eq_d;  // b==d
    assign out[15] = b_eq_e;  // b==e
    
    // c comparisons
    assign out[14] = a_eq_c;  // c==a
    assign out[13] = b_eq_c;  // c==b
    assign out[11] = c_eq_d;  // c==d
    assign out[10] = c_eq_e;  // c==e
    
    // d comparisons
    assign out[9]  = a_eq_d;  // d==a
    assign out[8]  = b_eq_d;  // d==b
    assign out[7]  = c_eq_d;  // d==c
    assign out[5]  = d_eq_e;  // d==e
    
    // e comparisons
    assign out[4]  = a_eq_e;  // e==a
    assign out[3]  = b_eq_e;  // e==b
    assign out[2]  = c_eq_e;  // e==c
    assign out[1]  = d_eq_e;  // e==d
endmodule