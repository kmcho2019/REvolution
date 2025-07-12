module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

// Continuous assignment mux: chooses b if both selectors are high, else a
assign out_assign = (sel_b1 & sel_b2) ? b : a;

// Procedural mux implemented with if-else inside always block
always @(*) begin
    if (sel_b1 & sel_b2) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule