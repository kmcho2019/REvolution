module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg; // Flip-flop to hold the state
assign state = state_reg; // Make state observable

// Update state based on specific conditions
always @(posedge clk) begin
    if (~a && b) begin // If a is low and b is high, set state to 1
        state_reg <= 1;
    end else if (a && ~b && ~state_reg) begin // If a is high, b is low, and state is 0, set state to 1
        state_reg <= 1;
    end else if (~a && ~b && state_reg) begin // If both a and b are low and state is 1, reset state to 0
        state_reg <= 0;
    end else if (a && b && ~state_reg) begin // If a and b are high and state is 0, set state to 1
        state_reg <= 1;
    end else if (a && b && state_reg) begin // If a and b are high and state is 1, reset state to 0
        state_reg <= 0;
    end
end

// Combinational logic for q based on b and state
assign q = (b && (~state_reg || a)); // q is high if b is high and either state is 0 or a is high

endmodule