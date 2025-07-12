module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

// Define states
reg state_A, state_B;
reg next_state_A, next_state_B;

// Define outputs
reg z_A, z_B;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

// Combinational logic for next state and output
always @(*) begin
    // Initialize next state to avoid latches
    next_state_A = state_A;
    next_state_B = state_B;

    // Output z
    if (state_A) begin
        z_A = ~x;
        z_B = 1'b0;
    end else if (state_B) begin
        z_A = 1'b0;
        z_B = x;
    end

    // Next state logic
    if (state_A && x) begin
        next_state_A = 1'b0;
        next_state_B = 1'b1;
    end else if (state_B) begin
        next_state_A = 1'b0;
        next_state_B = 1'b1;
    end else if (state_A && ~x) begin
        next_state_A = 1'b1;
        next_state_B = 1'b0;
    end
end

// Output z logic
assign z = (state_A ? z_A : 1'b0) | (state_B ? z_B : 1'b0);

endmodule