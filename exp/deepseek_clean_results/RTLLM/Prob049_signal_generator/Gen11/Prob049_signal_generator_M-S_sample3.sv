module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Active-low reset
        wave <= 5'b0;
    end else begin
        // Simplified direction control
        if (wave == 5'b11111) begin      // At max (31)
            wave <= wave - 1'b1;         // Start decrementing
        end else if (wave == 5'b00000) begin // At min (0)
            wave <= wave + 1'b1;         // Start incrementing
        end else begin
            wave <= wave + (wave[4] ? -1'b1 : 1'b1); // Continue current direction
        end
    end
end

endmodule