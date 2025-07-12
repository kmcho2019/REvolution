module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

reg sel_b_reg;

// Continuous assignment directly implements the mux condition without intermediates
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Always block updates sel_b_reg combinationally
always @(*) begin
    sel_b_reg = sel_b1 && sel_b2;
    if (sel_b_reg)
        out_always = b;
    else
        out_always = a;
end

endmodule