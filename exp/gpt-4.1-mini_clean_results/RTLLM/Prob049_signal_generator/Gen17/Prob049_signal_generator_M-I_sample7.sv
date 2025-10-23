module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    // Synchronous reset and combined wave/state update logic
    always @(posedge clk) begin
        if (!rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;
        end else begin
            if (state == 1'b0) begin
                // Increment wave until max 31
                if (wave == 5'd31) begin
                    state <= 1'b1;     // Switch to decrement mode
                    wave  <= wave - 5'd1; // Begin decrement next cycle
                end else begin
                    wave <= wave + 5'd1;
                end
            end else begin
                // Decrement wave until min 0
                if (wave == 5'd0) begin
                    state <= 1'b0;     // Switch to increment mode
                    wave  <= wave + 5'd1; // Begin increment next cycle
                end else begin
                    wave <= wave - 5'd1;
                end
            end
        end
    end

endmodule