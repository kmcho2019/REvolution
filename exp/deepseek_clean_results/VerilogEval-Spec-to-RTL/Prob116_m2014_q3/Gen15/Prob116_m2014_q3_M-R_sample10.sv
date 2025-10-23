module TopModule(
    input [3:0] x,  // x[3:0] maps to [x4,x3,x2,x1] in K-map
    output f
);
    wire not_x0;
    wire and_term1, and_term2;
    wire or_out;
    
    // First term: ~x[0] & x[2]
    not u1(not_x0, x[0]);
    and u2(and_term1, not_x0, x[2]);
    
    // Second term: x[0] & x[1] & x[3]
    and u3(and_term2, x[0], x[1], x[3]);
    
    // Combine terms
    or u4(f, and_term1, and_term2);
endmodule