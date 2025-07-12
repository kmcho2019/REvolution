module TopModule(
    input  d,
    input  ena,
    output q
);

reg q_reg;
assign q = q_reg;

always @(d or ena) begin
    if (ena) begin
        q_reg <= d;
    end else begin
        q_reg <= q_reg; // Retain the value when ena is low
    end
end

endmodule