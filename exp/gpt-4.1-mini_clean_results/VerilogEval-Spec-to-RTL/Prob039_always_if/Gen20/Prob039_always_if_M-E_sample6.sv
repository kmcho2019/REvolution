module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);
    // Combined select signal
    wire sel = sel_b1 & sel_b2;

    // Continuous assignment mux
    assign out_assign = sel ? b : a;

    // Procedural mux in always block
    always @(*) begin
        if (sel)
            out_always = b;
        else
            out_always = a;
    end

endmodule