module TopModule(
    input  d,
    input  ena,
    output q
);

reg q_reg; // internal reg to hold the output value
assign q = q_reg;

always @(*) begin
    if (ena) begin
        q_reg = d;
    end
end

endmodule