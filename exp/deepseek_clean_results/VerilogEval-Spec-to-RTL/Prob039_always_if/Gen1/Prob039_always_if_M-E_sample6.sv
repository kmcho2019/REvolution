module AssignMux (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out
);
    assign out = (sel_b1 & sel_b2) ? b : a;
endmodule

module AlwaysMux (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output reg out
);
    always @(*) begin
        out = (sel_b1 & sel_b2) ? b : a;
    end
endmodule

module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Instantiate assign-based mux
    AssignMux assign_mux_inst (
        .a(a),
        .b(b),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .out(out_assign)
    );

    // Instantiate always-based mux
    AlwaysMux always_mux_inst (
        .a(a),
        .b(b),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .out(out_always)
    );
endmodule