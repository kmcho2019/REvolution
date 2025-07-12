module TopModule(
    input [3:0] x,  // x[3:0] maps to [x4,x3,x2,x1] in K-map
    output f
);
    // Direct implementation without intermediate wires
    not u1(f_and1_term, x[0]);
    and u2(f_and1, f_and1_term, x[2]);
    and u3(f_and2, x[0], x[1], x[3]);
    or u4(f, f_and1, f_and2);
endmodule