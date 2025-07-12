module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg direction; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            direction <= 1'b0;
        end else begin
            // Update wave based on direction
            if (direction == 1'b0) begin
                // Counting up
                if (wave == 5'd31) begin
                    direction <= 1'b1;
                    wave <= wave - 5'd1;
                end else begin
                    wave <= wave + 5'd1;
                end
            end else begin
                // Counting down
                if (wave == 5'd0) begin
                    direction <= 1'b0;
                    wave <= wave + 5'd1;
                end else begin
                    wave <= wave - 5'd1;
                end
            end
        end
    end

endmodule