module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);
    wire sel_final = sel_b1 & sel_b2;
    wire mux_out;

    // Single combinational mux output
    assign mux_out = sel_final ? b : a;

    // Continuous assign output
    assign out_assign = mux_out;

    // Procedural output driven from same mux output
    always @(*) begin
        out_always = mux_out;
    end

endmodule