module TopModule(
    input  clock,
    input  a,
    output p,
    output q
);

reg p_reg; // Register for output p
reg q_reg; // Register for output q

always @(posedge clock) begin
    p_reg <= a; // Update p_reg at the positive edge of the clock
end

always @(negedge clock) begin
    if (p_reg == 1'b1) begin
        q_reg <= 1'b1; // Set q_reg to 1 if p_reg is 1 at the negative edge of the clock
    end else begin
        q_reg <= q_reg; // Keep q_reg unchanged
    end
end

assign p = p_reg; // Assign the value of p_reg to output p
assign q = q_reg; // Assign the value of q_reg to output q

endmodule