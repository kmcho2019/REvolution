module TopModule(
    input  d,
    input  ena,
    output q
);

reg q_reg; // internal register to hold the output value

always @(*) begin
    if (ena) begin
        q_reg = d;
    end
end

assign q = q_reg;

endmodule