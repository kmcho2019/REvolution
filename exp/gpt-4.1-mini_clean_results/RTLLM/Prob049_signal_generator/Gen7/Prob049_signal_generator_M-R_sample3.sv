module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 1'b0; // Start with increment direction
        end else begin
            // Change direction only when at boundary
            if ((state == 1'b0 && wave == 5'd31) || (state == 1'b1 && wave == 5'd0)) begin
                state <= ~state; // Toggle direction
            end
        end
    end

    // Waveform update
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
        end else begin
            if (state == 1'b0) begin // incrementing
                if (wave < 5'd31)
                    wave <= wave + 5'd1;
                else
                    wave <= wave; // hold at boundary for one cycle
            end else begin // decrementing
                if (wave > 5'd0)
                    wave <= wave - 5'd1;
                else
                    wave <= wave; // hold at boundary for one cycle
            end
        end
    end

endmodule