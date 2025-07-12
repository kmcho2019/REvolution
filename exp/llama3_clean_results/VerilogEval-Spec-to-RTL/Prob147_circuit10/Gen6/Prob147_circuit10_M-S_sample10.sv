module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg; // Single-bit flip-flop to hold the state
assign state = state_reg; // Make state observable

always @(posedge clk) begin
    if (!a && b) begin
        state_reg <= !state_reg;
    end else if (a && !b) begin
        state_reg <= 0;
    end
end

// Combinational logic for q based on b
assign q = b;

endmodule