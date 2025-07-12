module TopModule(
    input  d,
    input  ena,
    output q
);

reg q_reg; // internal register to hold the output
assign q = q_reg; // assign the internal register to the output

always @(*) begin
    if (ena) begin
        q_reg <= d; // update the internal register when enable is high
    end
end

endmodule