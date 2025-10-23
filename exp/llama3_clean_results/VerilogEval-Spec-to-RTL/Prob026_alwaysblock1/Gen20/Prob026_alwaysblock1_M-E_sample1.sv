module ParamAndGate #
(
    parameter use_always = 1
)
(
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

generate
    if (use_always) begin
        always @(*) begin
            out_alwaysblock = a & b;
        end
    end else begin
        assign out_assign = a & b;
    end
endgenerate

endmodule

module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

ParamAndGate #(.use_always(1)) u_and_gate_always(
   .a(a),
   .b(b),
   .out_assign(),
   .out_alwaysblock(out_alwaysblock)
);

ParamAndGate #(.use_always(0)) u_and_gate_assign(
   .a(a),
   .b(b),
   .out_assign(out_assign),
   .out_alwaysblock()
);

endmodule