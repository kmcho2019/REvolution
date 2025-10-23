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

    // Compute mux output once with assign
    wire mux_out;
    assign mux_out = sel_final ? b : a;

    // Continuous assign output directly from mux_out
    assign out_assign = mux_out;

    // Procedural mux output using if inside always block
    always @(*) begin
        if (sel_final) begin
            out_always = b;
        end else begin
            out_always = a;
        end
    end

endmodule