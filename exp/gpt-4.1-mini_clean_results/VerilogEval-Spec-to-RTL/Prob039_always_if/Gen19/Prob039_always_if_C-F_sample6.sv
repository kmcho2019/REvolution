module Mux2to1 (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire y
);
    // Combinational 2-to-1 mux implemented via continuous assignment
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

    wire sel_final = sel_b1 & sel_b2;  // Select b only if both sel_b1 and sel_b2 are high
    wire mux_out;

    // Single instance of Mux2to1 shared for both outputs
    Mux2to1 u_mux (
        .a(a),
        .b(b),
        .sel(sel_final),
        .y(mux_out)
    );

    // Continuous assignment output
    assign out_assign = mux_out;

    // Procedural output using always block and mux output
    always @(*) begin
        out_always = mux_out;
    end

endmodule