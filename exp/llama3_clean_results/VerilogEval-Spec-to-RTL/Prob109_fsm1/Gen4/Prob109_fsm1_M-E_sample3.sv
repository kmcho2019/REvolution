module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // Latch to represent state A
    reg state_A;
    reg state_B;

    // Latch enable logic based on current state and input
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 0;
            state_B <= 1;
        end else begin
            if (state_A && in) begin
                state_A <= 1;
                state_B <= 0;
            end else if (state_A && !in) begin
                state_A <= 0;
                state_B <= 1;
            end else if (!state_A && in) begin
                state_A <= 0;
                state_B <= 1;
            end else if (!state_A && !in) begin
                state_A <= 1;
                state_B <= 0;
            end
        end
    end

    // Output logic
    assign out = state_B;

endmodule