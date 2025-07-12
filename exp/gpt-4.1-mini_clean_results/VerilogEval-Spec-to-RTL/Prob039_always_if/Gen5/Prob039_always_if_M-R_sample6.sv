module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire sel_b1_and_b2;
assign sel_b1_and_b2 = sel_b1 & sel_b2;

assign out_assign = sel_b1_and_b2 ? b : a;

always @(*) begin
    if (sel_b1_and_b2) begin
        out_always <= b;
    end else begin
        out_always <= a;
    end
end

endmodule