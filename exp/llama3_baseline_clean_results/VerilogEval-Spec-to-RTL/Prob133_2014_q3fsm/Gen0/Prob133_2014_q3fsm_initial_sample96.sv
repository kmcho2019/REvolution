module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] count_w; // Count of w = 1 over three cycles
reg [1:0] cycle;   // Current cycle within the three-cycle window
reg in_B;         // Flag to indicate if we are in State B

always @(posedge clk) begin
    if (reset) begin
        // Reset all signals
        count_w <= 0;
        cycle <= 0;
        in_B <= 0;
        z <= 0;
    end else begin
        if (!in_B && s) begin
            // Transition from A to B
            in_B <= 1;
            cycle <= 1;
            count_w <= 0;
        end else if (in_B) begin
            // In State B, count occurrences of w = 1
            if (w) begin
                count_w <= count_w + 1;
            end
            // Increment cycle counter
            if (cycle < 3) begin
                cycle <= cycle + 1;
            end else begin
                // After three cycles, determine z and reset counters
                z <= (count_w == 2) ? 1 : 0;
                cycle <= 1; // Reset cycle counter
                count_w <= 0; // Reset count of w = 1
            end
        end
    end
end

endmodule