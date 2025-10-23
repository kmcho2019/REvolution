module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg direction; // 0 = up (increment), 1 = down (decrement)

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            direction <= 1'b0;
        end else begin
            if (direction == 1'b0) begin
                // Increment wave
                if (wave == 5'd31) begin
                    direction <= 1'b1; // Change direction to down
                    wave <= wave - 5'd1;
                end else begin
                    wave <= wave + 5'd1;
                end
            end else begin
                // Decrement wave
                if (wave == 5'd0) begin
                    direction <= 1'b0; // Change direction to up
                    wave <= wave + 5'd1;
                end else begin
                    wave <= wave - 5'd1;
                end
            end
        end
    end

endmodule