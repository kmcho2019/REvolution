module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);
    wire sel_combined = sel_b1 & sel_b2;
    wire mux_out;

    // Single continuous assignment mux output
    assign mux_out = sel_combined ? b : a;

    // Drive out_assign directly from mux_out
    assign out_assign = mux_out;

    // Procedural mux implementation with if-else for out_always
    always @(*) begin
        if (sel_combined)
            out_always = b;
        else
            out_always = a;
    end

endmodule