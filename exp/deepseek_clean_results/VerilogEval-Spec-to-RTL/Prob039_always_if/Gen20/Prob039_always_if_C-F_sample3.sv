module AssignMux (
    input a,
    input b,
    input sel,
    output out
);
    assign out = sel ? b : a;
endmodule

module AlwaysMux (
    input a,
    input b,
    input sel,
    output out
);
    always @(*) begin
        if (sel)
            out = b;
        else
            out = a;
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
    wire select_b = sel_b1 & sel_b2;
    
    // Assign-based implementation
    AssignMux assign_mux (
        .a(a),
        .b(b),
        .sel(select_b),
        .out(out_assign)
    );
    
    // Always-based implementation
    AlwaysMux always_mux (
        .a(a),
        .b(b),
        .sel(select_b),
        .out(out_always)
    );
endmodule