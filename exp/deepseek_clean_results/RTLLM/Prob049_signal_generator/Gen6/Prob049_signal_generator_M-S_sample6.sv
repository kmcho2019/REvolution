module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
    end else begin
        if (wave == 5'b11111) begin    // At max value
            wave <= wave - 1;          // Start decrementing
        end else if (wave == 5'b0) begin // At min value
            wave <= wave + 1;          // Start incrementing
        end else begin
            wave <= wave[4] ? wave - 1 : wave + 1; // Use MSB as direction
        end
    end
end

endmodule