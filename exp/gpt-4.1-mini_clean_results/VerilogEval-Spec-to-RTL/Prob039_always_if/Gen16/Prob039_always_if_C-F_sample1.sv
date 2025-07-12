module Mux2to1 (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire y
);
    // Pure combinational mux using assign
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
    wire sel_final;
    assign sel_final = sel_b1 & sel_b2;

    // Instantiate combinational mux for continuous assign output
    Mux2to1 mux_assign (
        .a(a),
        .b(b),
        .sel(sel_final),
        .y(out_assign)
    );

    // Instantiate combinational mux for procedural output
    wire mux_proc_out;
    Mux2to1 mux_proc (
        .a(a),
        .b(b),
        .sel(sel_final),
        .y(mux_proc_out)
    );

    // Procedural block assigning mux output to out_always
    always @(*) begin
        out_always = mux_proc_out;
    end

endmodule