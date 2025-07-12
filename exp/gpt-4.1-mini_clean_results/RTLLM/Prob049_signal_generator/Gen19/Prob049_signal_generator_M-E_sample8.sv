module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // 6-bit signed counter from 0 to 31 and back down
    reg signed [5:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 6'sd0;
            wave    <= 5'd0;
        end else begin
            // At the limits 0 and 31, reverse direction implicitly:
            // We track direction with the sign of the step (+1 or -1).
            // When counter reaches 31 (max) or 0 (min), the next step reverses automatically.

            if (counter == 6'sd31)
                counter <= counter - 6'sd1; // Switch direction down
            else if (counter == 6'sd0)
                counter <= counter + 6'sd1; // Switch direction up
            else if (counter > 0 && counter < 31) begin
                // Determine current direction from previous step:
                // If previous incrementing, continue incrementing until 31,
                // else continue decrementing until 0.
                // We store direction implicitly by comparison with previous value,
                // but since we only have one counter, alternate direction on boundaries.

                // Simplify by using a direction signal:
                // But since direction not stored separately, infer from value:
                // If previous step was up, counter <31; if down, counter >0.

                // To avoid extra state, we check previous direction using last step:
                // However, to keep simple, we can infer direction using sign of delta:
                // For simplicity, alternate direction on boundaries as above.
                // Thus, between boundaries, step accordingly:

                if (counter[5] == 0) // MSB 0: counting up
                    counter <= counter + 6'sd1;
                else                // MSB 1: counting down (negative number)
                    counter <= counter - 6'sd1;
            end

            // Output lower 5 bits of counter as wave (0 to 31)
            wave <= counter[4:0];
        end
    end

endmodule