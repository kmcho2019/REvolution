module BaseAndGate (
    input a,
    input b,
    output y
);
    // Transistor-level inspired implementation
    wire w1;
    supply1 vdd;
    supply0 gnd;
    
    pmos p1(y, vdd, a);
    pmos p2(y, vdd, b);
    nmos n1(w1, gnd, a);
    nmos n2(y, w1, b);
endmodule

module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Assign implementation using direct primitive
    and and1(out_assign, a, b);
    
    // Always block implementation using hierarchical design
    wire and_out;
    BaseAndGate u_base(.a(a), .b(b), .y(and_out));
    
    always @(*) begin
        out_alwaysblock = and_out;
    end
endmodule