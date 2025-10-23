module PrimitiveAnd (
    input a,
    input b,
    output out
);
    // Gate-level implementation of AND
    and g1(out, a, b);
endmodule

module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Direct instantiation for assign version
    PrimitiveAnd u_assign (.a(a), .b(b), .out(out_assign));
    
    // Wrapped version for always block
    wire and_out;
    PrimitiveAnd u_prim (.a(a), .b(b), .out(and_out));
    
    always @(*) begin
        out_alwaysblock = and_out;
    end
endmodule