module TopModule(
    input  clk,
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

reg out_assign_reg;
reg out_always_reg;

always @(posedge clk) begin
    if (sel_b1 && sel_b2) begin
        out_assign_reg <= b;
        out_always_reg <= b;
    end else begin
        out_assign_reg <= a;
        out_always_reg <= a;
    end
end

assign out_assign = out_assign_reg;
assign out_always = out_always_reg;

endmodule