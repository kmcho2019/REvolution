module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

// Using assign statement for combinational logic
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Simplified always block using ternary operator
always @(*) begin
    out_always = (sel_b1 && sel_b2) ? b : a;
end

endmodule