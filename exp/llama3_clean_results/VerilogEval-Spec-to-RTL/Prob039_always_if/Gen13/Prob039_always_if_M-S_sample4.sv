module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

// Use assign statement for direct assignment
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Use always block with procedural if statement for procedural assignment
always @(*) begin
    out_always = (sel_b1 && sel_b2) ? b : a;
end

endmodule