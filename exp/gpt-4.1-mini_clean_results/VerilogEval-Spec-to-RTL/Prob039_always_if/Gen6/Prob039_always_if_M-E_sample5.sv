module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire enable_b = sel_b1 & sel_b2;

assign out_assign = enable_b ? b : a;

always @(*) begin
    if (enable_b) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule