module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

// Use assign statement for out_assign
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Use always block for out_always
always @(*) begin
    out_always = (sel_b1 && sel_b2) ? b : a;
end

endmodule