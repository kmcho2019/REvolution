module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

    // Combined select signal to choose 'b' only if both sel_b1 and sel_b2 are true
    wire sel_final = sel_b1 & sel_b2;

    // Continuous assignment 2-to-1 mux: select b if sel_final else a
    assign out_assign = sel_final ? b : a;

    // Procedural 2-to-1 mux with explicit if-else inside always block
    always @(*) begin
        if (sel_final)
            out_always = b;
        else
            out_always = a;
    end

endmodule