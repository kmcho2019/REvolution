module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output reg out_assign,
    output reg out_always
);

// Single always block for both outputs
always @(*) begin
    out_assign = (sel_b1 && sel_b2) ? b : a;
    out_always = out_assign;
end

endmodule