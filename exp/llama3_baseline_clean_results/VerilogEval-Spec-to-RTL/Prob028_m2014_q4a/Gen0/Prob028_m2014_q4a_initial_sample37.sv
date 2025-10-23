module TopModule(
    input  d,
    input  ena,
    output q
);

reg q_reg; // Internal register for the latch output
assign q = q_reg; // Continuous assignment for the output

always @(*) begin
    if (ena) begin
        q_reg = d; // Capture the input 'd' when 'ena' is high
    end
end

endmodule