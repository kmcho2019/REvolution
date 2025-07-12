module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
    end
    else begin
        if (&wave) begin           // At max value (all 1s)
            wave <= wave - 1'b1;   // Start decrementing
        end
        else if (wave == 5'b0) begin // At min value
            wave <= wave + 1'b1;    // Start incrementing
        end
        else begin
            wave <= wave + (wave[4] ? -1'b1 : 1'b1); // Use MSB as direction
        end
    end
end

endmodule