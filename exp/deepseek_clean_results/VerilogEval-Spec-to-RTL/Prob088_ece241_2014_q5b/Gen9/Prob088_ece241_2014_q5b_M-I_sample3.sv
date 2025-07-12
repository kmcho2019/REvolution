module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state_A, state_B;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
            z <= 1'b0;
        end
        else begin
            if (state_A) begin
                state_A <= ~x;
                state_B <= x;
                z <= x;  // Only update z when in state_A
            end
            // state_B is sticky - no transition needed once set
        end
    end

    // Output logic for state_B (constant 1 after first x=1)
    always @(*) begin
        if (~state_A) z = ~x;
    end

endmodule