module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg q_reg;
assign p = a & clock;
always @(posedge clock) begin
    if(a) begin
        q_reg <= 1;
    end else begin
        q_reg <= 0;
    end
end

assign q = q_reg;

endmodule