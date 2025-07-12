module TransistorAnd #(
    parameter DELAY = 1
) (
    input a,
    input b,
    output out
);
    wire n1, n2;
    
    // PMOS transistors for pull-up network
    pmos #DELAY P1(out, 1'b1, a);
    pmos #DELAY P2(out, 1'b1, b);
    
    // NMOS transistors for pull-down network
    nmos #DELAY N1(n1, 1'b0, a);
    nmos #DELAY N2(out, n1, b);
endmodule

module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Assign version with minimal delay
    assign #1 out_assign = a & b;
    
    // Always block version with transistor-level implementation
    TransistorAnd #(2) u_trans_and (.a(a), .b(b), .out(out_alwaysblock));
endmodule