module TransistorAnd (
    input a,
    input b,
    output out
);
    // Transistor-level AND gate implementation
    wire w1, w2;
    
    // Pull-up network (PMOS)
    pmos p1(w1, 1'b1, a);
    pmos p2(out, w1, b);
    
    // Pull-down network (NMOS)
    nmos n1(out, w2, a);
    nmos n2(w2, 1'b0, b);
endmodule

module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Behavioral AND using assign statement
    assign out_assign = a & b;
    
    // Transistor-level AND using always block
    wire transistor_and_out;
    TransistorAnd u_transistor_and (
        .a(a),
        .b(b),
        .out(transistor_and_out)
    );
    
    always @(*) begin
        out_alwaysblock = transistor_and_out;
    end
endmodule