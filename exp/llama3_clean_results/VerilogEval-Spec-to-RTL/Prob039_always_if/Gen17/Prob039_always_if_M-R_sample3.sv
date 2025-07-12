// The top module implements the 2-to-1 multiplexer logic
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

// Direct assignment logic using assign statement
assign out_assign = (sel_b1 && sel_b2)? b : a;

// Procedural assignment logic using always block
always @(*) begin
    out_always = (sel_b1 && sel_b2)? b : a;
end

endmodule