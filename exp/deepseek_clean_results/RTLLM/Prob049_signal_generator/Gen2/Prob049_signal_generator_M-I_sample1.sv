module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state; // 0 for incrementing, 1 for decrementing (Gray encoded)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        state <= 1'b0;
    end
    else begin
        case (state)
            1'b0: begin // Incrementing phase
                if (wave == 5'd30) begin
                    wave <= 5'd31;
                    state <= 1'b1; // Switch to decrement at next cycle
                end
                else if (wave == 5'd31) begin
                    wave <= 5'd30;
                    state <= 1'b1; // Already at peak, start descending
                end
                else begin
                    wave <= wave + 1;
                end
            end
            1'b1: begin // Decrementing phase
                if (wave == 5'd1) begin
                    wave <= 5'd0;
                    state <= 1'b0; // Switch to increment at next cycle
                end
                else if (wave == 5'd0) begin
                    wave <= 5'd1;
                    state <= 1'b0; // Already at bottom, start ascending
                end
                else begin
                    wave <= wave - 1;
                end
            end
        endcase
    end
end

endmodule