module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output reg out_assign,
    output reg out_always
);

always @(*) begin
    // Continuous assignment for out_assign within the always block
    out_assign = (sel_b1 && sel_b2)? b : a;
    
    // Procedural assignment for out_always
    out_always = (sel_b1 && sel_b2)? b : a;
end

endmodule