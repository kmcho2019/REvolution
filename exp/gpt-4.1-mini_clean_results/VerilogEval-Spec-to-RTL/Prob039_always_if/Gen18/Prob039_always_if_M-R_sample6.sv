module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);
    wire sel = sel_b1 & sel_b2;

    // Continuous assignment implementing mux logic
    assign out_assign = sel ? b : a;

    // Procedural always block implementing mux logic with if statement
    always @(*) begin
        if (sel)
            out_always = b;
        else
            out_always = a;
    end

endmodule