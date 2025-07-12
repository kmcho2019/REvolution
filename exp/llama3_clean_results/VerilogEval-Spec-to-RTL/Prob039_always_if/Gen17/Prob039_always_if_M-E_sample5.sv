module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

// Implement the 2-to-1 multiplexer using assign statement
assign out_assign = (sel_b1 & sel_b2)? b : a;

// Implement the 2-to-1 multiplexer using always block
logic internal_out_always;
always @(*) begin
    internal_out_always = (sel_b1 & sel_b2)? b : a;
    out_always = internal_out_always;
end

endmodule