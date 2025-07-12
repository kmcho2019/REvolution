module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

// Method 1: Using assign statement
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Method 2: Using procedural if statement within an always block
always @(*)
begin
    if (sel_b1 && sel_b2)
        out_always = b;
    else
        out_always = a;
end

endmodule