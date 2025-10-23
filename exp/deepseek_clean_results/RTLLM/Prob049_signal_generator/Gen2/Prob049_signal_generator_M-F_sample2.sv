module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0=increment, 1=decrement

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;  // Start incrementing
    end
    else begin
        // Check boundaries and update direction
        if (&wave) begin       // When wave == 31
            direction <= 1'b1; // Switch to decrement
        end
        else if (~|wave) begin // When wave == 0
            direction <= 1'b0; // Switch to increment
        end

        // Update wave value based on direction
        if (direction) begin
            wave <= wave - 1'b1;
        end
        else begin
            wave <= wave + 1'b1;
        end
    end
end

endmodule