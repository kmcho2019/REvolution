module Mux2to1 (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire y
);
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
    wire sel_final = sel_b1 & sel_b2;

    // Single mux instance generating shared output wire
    wire mux_out;
    Mux2to1 shared_mux (
        .a(a),
        .b(b),
        .sel(sel_final),
        .y(mux_out)
    );

    // Continuous assign output driven by mux_out
    assign out_assign = mux_out;

    // Procedural assignment using the shared mux output
    always @(*) begin
        out_always = mux_out;
    end

endmodule