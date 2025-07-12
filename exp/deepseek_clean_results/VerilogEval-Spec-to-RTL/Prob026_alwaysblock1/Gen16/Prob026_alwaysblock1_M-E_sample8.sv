module TransistorAnd (
    input a,
    input b,
    output out
);
    supply1 vdd;
    supply0 gnd;
    
    wire net1, net2;
    
    // PMOS network for pull-up
    pmos p1(net1, vdd, a);
    pmos p2(out, net1, b);
    
    // NMOS network for pull-down
    nmos n1(out, net2, a);
    nmos n2(net2, gnd, b);
endmodule

module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);
    wire and_out;
    
    // Transistor-level AND implementation
    TransistorAnd u_and (
        .a(a),
        .b(b),
        .out(and_out)
    );
    
    // Assign output
    assign out_assign = and_out;
    
    // Always block output
    always @(*) begin
        out_alwaysblock = and_out;
    end
endmodule