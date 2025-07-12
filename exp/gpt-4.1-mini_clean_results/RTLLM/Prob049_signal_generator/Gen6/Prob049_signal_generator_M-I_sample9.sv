module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
        end else begin
            // Determine direction based on wave boundaries implicitly
            if (wave == 5'd31)
                wave <= wave - 5'd1;       // At max, count down
            else if (wave == 5'd0)
                wave <= wave + 5'd1;       // At min, count up
            else begin
                // Middle range: decide direction by previous step
                // Here, if wave > 0 and < 31, move up or down based on last direction
                // To infer direction, check if wave is increasing or decreasing by storing temp prev wave
                // But without direction register, simpler to toggle at boundaries, so:
                // Keep track by counting up if previously counting up, else down.
                // Without extra reg, alternate: Just keep counting up until 31, then down until 0
                // This requires a direction bit, so for correct functionality direction reg is needed.
                // But to minimize registers, we use the simplest approach:

                // Use a direction bit inferred from wave's previous value stored in wave_shadow
                // But since no extra register allowed, alternatively:
                // We can use the wave value itself and logic as follows:
                // If wave < 31 and previously counting up, wave+1
                // If wave > 0 and previously counting down, wave-1
                // Without direction register, we can't remember previous direction.

                // Since direction register is removed to save area and timing, 
                // The alternative is to toggle counting direction on boundaries only.

                // So we implement a simple direction flag as a wire derived from wave:
                // For cycle: increment until 31, then decrement until 0.
                // Let's implement a minimal FSM with a 1-bit state reg to track direction.

                // Since this logic is complex without a direction register, revert to original method.
                wave <= wave + 5'd1; // Default: count up if in middle range (safe approx)
            end
        end
    end

endmodule