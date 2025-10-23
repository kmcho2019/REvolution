module Mux2to1(
    input a,
    input b,
    input sel,
    output out
);
    assign out = sel ? b : a;
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
    
    // Assign-based implementation using submodule
    Mux2to1 mux_assign (
        .a(a),
        .b(b),
        .sel(select_b),
        .out(out_assign)
    );
    
    // Always-based implementation using submodule
    reg out_always_reg;
    always @(*) begin
        if (select_b)
            out_always_reg = b;
        else
            out_always_reg = a;
    end
    assign out_always = out_always_reg;
endmodule