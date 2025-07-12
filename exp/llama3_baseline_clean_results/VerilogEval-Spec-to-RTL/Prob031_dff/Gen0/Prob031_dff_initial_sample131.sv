module TopModule(
    input clk,
    input d,
    output q
);

reg q_reg; // Internal register to hold the value of q
assign q = q_reg; // Assign the internal register to the output q

always_ff @(posedge clk) begin
    q_reg <= d; // On the positive edge of the clock, assign d to q_reg
end

endmodule