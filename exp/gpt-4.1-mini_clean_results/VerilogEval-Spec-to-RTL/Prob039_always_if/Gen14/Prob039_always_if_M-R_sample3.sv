module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output reg  out_assign,
    output      out_always
);

// Procedural mux implemented inside an always block for out_assign using ternary operator
always @(*) begin
    out_assign = (sel_b1 & sel_b2) ? b : a;
end

// Continuous assignment implementing the mux for out_always
assign out_always = (sel_b1 & sel_b2) ? b : a;

endmodule