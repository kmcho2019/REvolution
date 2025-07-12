module ParamAnd #(
    parameter USE_ASSIGN = 1
) (
    input a,
    input b,
    output reg out
);
    generate
        if (USE_ASSIGN) begin
            assign out = a & b;
        end else begin
            always @(*) out = a & b;
        end
    endgenerate
endmodule

module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    ParamAnd #(.USE_ASSIGN(1)) u_assign (.a(a), .b(b), .out(out_assign));
    ParamAnd #(.USE_ASSIGN(0)) u_always (.a(a), .b(b), .out(out_alwaysblock));
endmodule