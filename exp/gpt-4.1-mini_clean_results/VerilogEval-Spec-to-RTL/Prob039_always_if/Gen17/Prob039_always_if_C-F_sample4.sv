module Mux2to1(
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire y
);
    // Simple continuous assignment 2-to-1 mux
    assign y = sel ? b : a;
endmodule

module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);
    wire sel_combined;
    assign sel_combined = sel_b1 & sel_b2;

    // Continuous assignment mux instance for out_assign
    Mux2to1 mux_assign (
        .a(a),
        .b(b),
        .sel(sel_combined),
        .y(out_assign)
    );

    // Procedural always block mux logic for out_always
    always @(*) begin
        if (sel_combined)
            out_always = b;
        else
            out_always = a;
    end
endmodule