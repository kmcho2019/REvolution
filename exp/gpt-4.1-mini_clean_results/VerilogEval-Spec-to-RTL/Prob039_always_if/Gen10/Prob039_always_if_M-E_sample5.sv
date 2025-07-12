module Mux2to1(
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire y
);
    // Continuous assignment mux: y = b if sel=1 else a
    assign y = sel ? b : a;
endmodule

module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

    wire sel_final;
    wire out_assign_wire;

    // Generate combined select signal
    assign sel_final = sel_b1 & sel_b2;

    // Instantiate mux for continuous assignment output
    Mux2to1 u_mux_assign (
        .a(a),
        .b(b),
        .sel(sel_final),
        .y(out_assign_wire)
    );

    assign out_assign = out_assign_wire;

    // Instantiate mux for procedural output (inside always block)
    always @(*) begin
        if (sel_final)
            out_always = b;
        else
            out_always = a;
    end

endmodule