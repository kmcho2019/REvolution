module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output reg out_assign,
    output reg out_always
);

// Use continuous assignment statement to implement the mux logic
assign out_assign = (sel_b1 && sel_b2)? b : a;

// Use always block with procedural if statement to achieve the same logic
always @(*)
begin
    // Use simple if-else statement to decide whether to assign 'a' or 'b' to out_always
    out_always = (sel_b1 && sel_b2)? b : a;
end

endmodule