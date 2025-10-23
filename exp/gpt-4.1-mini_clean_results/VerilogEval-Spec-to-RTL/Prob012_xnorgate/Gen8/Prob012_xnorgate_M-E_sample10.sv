module and_gate(
    input a,
    input b,
    output y
);
    assign y = a & b;
endmodule

module or_gate(
    input a,
    input b,
    output y
);
    assign y = a | b;
endmodule

module not_gate(
    input in,
    output out
);
    assign out = ~in;
endmodule

module TopModule(
    input a,
    input b,
    output out
);
    wire not_a, not_b;
    wire and1_out, and2_out;
    
    not_gate u_not_a (
        .in(a),
        .out(not_a)
    );
    
    not_gate u_not_b (
        .in(b),
        .out(not_b)
    );
    
    and_gate u_and1 (
        .a(a),
        .b(b),
        .y(and1_out)
    );
    
    and_gate u_and2 (
        .a(not_a),
        .b(not_b),
        .y(and2_out)
    );
    
    or_gate u_or (
        .a(and1_out),
        .b(and2_out),
        .y(out)
    );
endmodule