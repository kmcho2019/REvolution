module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire sel_b = sel_b1 & sel_b2;
wire selected_input;

assign selected_input = sel_b ? b : a;
assign out_assign = selected_input;

always @(*) begin
    if (sel_b)
        out_always = b;
    else
        out_always = a;
end

endmodule