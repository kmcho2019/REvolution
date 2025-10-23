module AssignMux (
    input a,
    input b,
    input select_b,
    output out
);
    assign out = select_b ? b : a;
endmodule

module AlwaysMux (
    input a,
    input b,
    input select_b,
    output reg out
);
    always @(*) begin
        out = select_b ? b : a;
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
    // Shared selection logic
    wire select_b = sel_b1 & sel_b2;

    // Instantiate optimized assign-based mux
    AssignMux assign_mux_inst (
        .a(a),
        .b(b),
        .select_b(select_b),
        .out(out_assign)
    );

    // Instantiate always-based mux
    AlwaysMux always_mux_inst (
        .a(a),
        .b(b),
        .select_b(select_b),
        .out(out_always)
    );
endmodule