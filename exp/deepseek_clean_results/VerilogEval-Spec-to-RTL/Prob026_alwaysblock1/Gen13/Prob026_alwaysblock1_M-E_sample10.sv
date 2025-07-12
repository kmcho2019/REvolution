module ConfigurableAndGate #(
    parameter USE_ASSIGN = 1
) (
    input a,
    input b,
    output out
);
    generate
        if (USE_ASSIGN) begin : assign_impl
            assign out = a & b;
        end else begin : always_impl
            reg out_reg;
            always @(*) out_reg = a & b;
            assign out = out_reg;
        end
    endgenerate
endmodule

module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    ConfigurableAndGate #(.USE_ASSIGN(1)) u_assign (.a(a), .b(b), .out(out_assign));
    ConfigurableAndGate #(.USE_ASSIGN(0)) u_always (.a(a), .b(b), .out(out_alwaysblock));
endmodule