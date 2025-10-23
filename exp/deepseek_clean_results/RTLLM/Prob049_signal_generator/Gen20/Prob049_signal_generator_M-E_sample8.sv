module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [5:0] counter;  // Extra bit for direction control

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 6'b0;
        wave <= 5'b0;
    end else begin
        // MSB of counter indicates direction (0=up, 1=down)
        if (counter[5] == 1'b0) begin
            // Increment phase
            if (wave == 5'd30) begin
                counter <= counter + 6'd2;  // Skip to downward phase
                wave <= wave + 1'b1;
            end else begin
                counter <= counter + 6'd1;
                wave <= wave + 1'b1;
            end
        end else begin
            // Decrement phase
            if (wave == 5'd1) begin
                counter <= 6'd0;  // Reset to upward phase
                wave <= wave - 1'b1;
            end else begin
                counter <= counter - 6'd1;
                wave <= wave - 1'b1;
            end
        end
    end
end

endmodule