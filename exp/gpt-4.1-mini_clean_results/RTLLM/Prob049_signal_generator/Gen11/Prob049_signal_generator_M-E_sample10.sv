module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // Use a 6-bit signed register: bit[5] is direction (0=up,1=down), bits[4:0] is wave value
    reg signed [5:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            cnt <= 6'd0;         // direction=0 (increment), value=0
            wave <= 5'd0;
        end else begin
            // Extract current direction and value
            // Direction: cnt[5], Wave: cnt[4:0]
            // Increment or decrement based on direction bit
            if (cnt[5] == 1'b0) begin
                // Counting up
                if (cnt[4:0] == 5'd31) begin
                    // Reverse direction at max
                    cnt <= {1'b1, cnt[4:0]} - 6'd1; // Switch to down and decrement
                    wave <= 5'd30;
                end else begin
                    cnt <= cnt + 6'd1;
                    wave <= cnt[4:0] + 5'd1;
                end
            end else begin
                // Counting down
                if (cnt[4:0] == 5'd0) begin
                    // Reverse direction at min
                    cnt <= {1'b0, 5'd0} + 6'd1; // Switch to up and increment
                    wave <= 5'd1;
                end else begin
                    cnt <= cnt - 6'd1;
                    wave <= cnt[4:0] - 5'd1;
                end
            end
        end
    end

endmodule