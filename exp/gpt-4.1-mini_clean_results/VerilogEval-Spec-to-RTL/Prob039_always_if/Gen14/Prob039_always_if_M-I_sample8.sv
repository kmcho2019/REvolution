module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

    wire sel_final;

    // Combined select signal
    assign sel_final = sel_b1 & sel_b2;

    // Direct continuous assignment mux, avoiding extra module instantiation
    assign out_assign = sel_final ? b : a;

    // Procedural mux implementation using always block
    always @(*) begin
        if (sel_final)
            out_always = b;
        else
            out_always = a;
    end

endmodule