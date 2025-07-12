// The top module implements the 2-to-1 multiplexer logic directly
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

// Implement the 2-to-1 multiplexer using an assign statement
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Implement the 2-to-1 multiplexer using a procedural if statement
always @(*) begin
    out_always = (sel_b1 && sel_b2) ? b : a;
end

endmodule