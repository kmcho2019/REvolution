module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

// Use assign statement to implement the 2-to-1 multiplexer
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Use always block with procedural if statement to implement the same logic
always @(*) begin
    if (sel_b1 && sel_b2) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule