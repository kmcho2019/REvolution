module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

    // Shared selection signal indicating when to choose b
    wire sel_b = sel_b1 & sel_b2;

    // Continuous assignment implementation using shared selection signal
    assign out_assign = sel_b ? b : a;

    // Procedural implementation using always block and shared selection signal
    always @(*) begin
        if (sel_b)
            out_always = b;
        else
            out_always = a;
    end

endmodule