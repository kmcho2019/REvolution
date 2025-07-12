module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire use_b;
assign use_b = sel_b1 & sel_b2;

assign out_assign = use_b ? b : a;

always @(*) begin
    if (use_b) begin
        if (out_always !== b) // reduce unnecessary toggling
            out_always <= b;
    end else begin
        if (out_always !== a)
            out_always <= a;
    end
end

endmodule