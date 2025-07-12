module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

// Continuous assignment: out_assign will always reflect the result of the 2-to-1 mux logic
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Procedural assignment using an always block
always @(*) begin
    // Use a conditional statement to determine the output of the 2-to-1 mux
    if (sel_b1 && sel_b2) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule