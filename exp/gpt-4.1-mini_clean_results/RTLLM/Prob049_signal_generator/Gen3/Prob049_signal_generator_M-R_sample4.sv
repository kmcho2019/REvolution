module signal_generator (
    input  wire       clk,
    input  wire       rst_n,
    output reg [4:0]  wave
);

    reg direction; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave      <= 5'd0;
            direction <= 1'b0; // start by incrementing
        end else begin
            // Determine next direction based on current wave value
            if (direction == 1'b0) begin
                // Currently incrementing
                if (wave == 5'd31)
                    direction <= 1'b1; // switch to decrement
            end else begin
                // Currently decrementing
                if (wave == 5'd0)
                    direction <= 1'b0; // switch to increment
            end

            // Update wave based on direction
            if (direction == 1'b0)
                wave <= wave + 5'd1;
            else
                wave <= wave - 5'd1;
        end
    end

endmodule