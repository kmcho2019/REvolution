module TopModule(
    input  d,
    input  ena,
    output q
);

reg q_reg;

always @(*) begin
    if (ena) begin
        q_reg = d;
    end
end

assign q = q_reg;

endmodule