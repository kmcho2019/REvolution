module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg; // Internal register to store the state
assign state = state_reg; // Assign the internal state to the output

// Combinational logic for the next state
always @(*) begin
    if (a == 1'b1 && b == 1'b0) begin
        // State remains the same when 'a' is 1 and 'b' is 0
        state_reg = state_reg;
    end else if (a == 1'b0 && b == 1'b1) begin
        // State becomes 1 when 'a' is 0 and 'b' is 1
        state_reg = 1'b1;
    end else if (a == 1'b0 && b == 1'b0) begin
        // State becomes 1 when 'a' is 0 and 'b' is 0, and current state is 0
        if (state_reg == 1'b0) begin
            state_reg = 1'b1;
        end else begin
            state_reg = state_reg;
        end
    end else begin
        // State remains the same when 'a' is 1 and 'b' is 1
        state_reg = state_reg;
    end
end

// Sequential logic for the next state
always @(posedge clk) begin
    // Update the state at the positive edge of the clock
    if (a == 1'b1 && b == 1'b1) begin
        // State becomes the inverse of the current state
        state_reg <= ~state_reg;
    end else if (a == 1'b0 && b == 1'b0) begin
        // State becomes 0
        state_reg <= 1'b0;
    end else begin
        // No change
        state_reg <= state_reg;
    end
end

// Combinational logic for output 'q'
assign q = (a == 1'b0) ? b : ~state;

endmodule