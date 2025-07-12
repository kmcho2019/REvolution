module TopModule(
    input  d,
    input  ena,
    output q
);

reg q_reg; // Internal register to hold the output value
assign q = q_reg; // Continuously assign the internal register to the output

always @(*) begin
    if (ena) begin
        q_reg <= d; // When ena is high, capture the value of d
    end else begin
        // When ena is low, retain the previous value
        // No action needed here as q_reg will keep its current value
    end
end

endmodule