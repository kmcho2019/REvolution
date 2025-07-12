module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg q_reg = 0;

always @(negedge clock) begin
    if (a) begin
        q_reg <= 1;
    end else begin
        q_reg <= 0;
    end
end

assign p = (clock && a);
assign q = q_reg;

endmodule