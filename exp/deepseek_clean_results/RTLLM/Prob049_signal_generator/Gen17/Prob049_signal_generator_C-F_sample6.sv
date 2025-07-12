module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        // Update wave value based on current direction
        wave <= direction ? (wave - 1'b1) : (wave + 1'b1);
        
        // Check for direction change conditions
        if ((&wave && !direction) || (wave == 5'b0 && direction)) begin
            direction <= ~direction;
        end
    end
end

endmodule