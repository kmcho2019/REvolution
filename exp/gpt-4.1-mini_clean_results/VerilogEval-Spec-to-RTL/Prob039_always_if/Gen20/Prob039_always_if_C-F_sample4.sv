module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    wire sel_final = sel_b1 & sel_b2;
    wire mux_out = sel_final ? b : a;

    // Continuous assignment output using mux expression
    assign out_assign = mux_out;

    // Procedural output using explicit if statement inside always block
    always @(*) begin
        if (sel_final) begin
            out_always = b;
        end else begin
            out_always = a;
        end
    end

endmodule