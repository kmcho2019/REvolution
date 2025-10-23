module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg; // Internal register for the flip-flop's state

// Combinational logic to determine the next state
assign q = (b && !state_reg) || (a && b && state_reg);

// Sequential logic (D flip-flop) to store the state
always @(posedge clk) begin
    if (!a && b) begin
        state_reg <= 1'b1;
    end else if (a && b && state_reg) begin
        state_reg <= 1'b1;
    end else begin
        state_reg <= 1'b0;
    end
end

// Output the current state
assign state = state_reg;

endmodule