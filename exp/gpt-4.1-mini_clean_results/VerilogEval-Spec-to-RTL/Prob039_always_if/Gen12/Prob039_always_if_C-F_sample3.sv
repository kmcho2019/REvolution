module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    // Shared combined select signal
    wire sel_final = sel_b1 & sel_b2;

    // Shared combinational mux output wire
    wire mux_out = sel_final ? b : a;

    // Continuous assignment output uses shared mux_out
    assign out_assign = mux_out;

    // Procedural mux output uses same select signal, explicit if-else
    always @(*) begin
        if (sel_final)
            out_always = b;
        else
            out_always = a;
    end

endmodule