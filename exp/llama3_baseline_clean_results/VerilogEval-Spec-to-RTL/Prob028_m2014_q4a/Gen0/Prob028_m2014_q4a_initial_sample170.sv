module TopModule(
    input  d,
    input  ena,
    output q
);

reg q_reg; // Internal register for storing the latch value
assign q = q_reg; // Continuous assignment to output the latch value

always @(*) begin
    if (ena) begin
        q_reg = d; // When ena is high, capture the input data
    end else begin
        // When ena is low, do nothing, thus holding the current value
    end
end

endmodule