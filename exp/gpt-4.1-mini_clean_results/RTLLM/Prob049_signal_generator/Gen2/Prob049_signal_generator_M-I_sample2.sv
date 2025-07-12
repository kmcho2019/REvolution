module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg direction; // 0 = up, 1 = down

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave      <= 5'd0;
            direction <= 1'b0; // start counting up
        end else begin
            // Update wave based on direction
            if (direction == 1'b0) begin
                wave <= wave + 1;
                if (wave == 5'd30) // preemptive toggle direction before next increment to 31
                    direction <= 1'b1;
            end else begin
                wave <= wave - 1;
                if (wave == 5'd1)  // preemptive toggle direction before next decrement to 0
                    direction <= 1'b0;
            end
        end
    end

endmodule