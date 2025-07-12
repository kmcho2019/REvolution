module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 1 = increment, 0 = decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b1;  // Start counting up
    end else begin
        // Update wave value based on current direction
        wave <= direction ? wave + 1'b1 : wave - 1'b1;
        
        // Automatically reverse direction at boundaries
        if ((wave == 5'b11110 && direction) ||  // About to hit 31
            (wave == 5'b00001 && !direction))   // About to hit 0
            direction <= ~direction;
    end
end

endmodule