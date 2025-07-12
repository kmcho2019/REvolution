module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

    wire sel_final = sel_b1 & sel_b2;

    // Continuous assignment mux output
    assign out_assign = sel_final ? b : a;

    // Procedural mux output using if statement
    always @(*) begin
        if (sel_final)
            out_always = b;
        else
            out_always = a;
    end

endmodule