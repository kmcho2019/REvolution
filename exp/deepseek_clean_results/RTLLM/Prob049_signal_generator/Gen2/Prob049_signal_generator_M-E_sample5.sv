module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = +1 (count up), 1 = -1 (count down)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;  // Start counting up
    end
    else begin
        // Update wave value based on current direction
        wave <= wave + {4'b0, ~direction} + {4'b0, direction};
        
        // Check boundaries and toggle direction if needed
        if ((wave == 5'b11111 && !direction) || (wave == 5'b00000 && direction))
            direction <= ~direction;
    end
end

endmodule