module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg; // Internal register to hold the state of q
assign q = q_reg; // Continuous assignment to output q

always @(posedge clk) begin
    if (a == 1'b1) begin
        q_reg <= ~q_reg; // Toggle q when a is high
    end else begin
        q_reg <= q_reg; // Hold q when a is low
    end
end

endmodule