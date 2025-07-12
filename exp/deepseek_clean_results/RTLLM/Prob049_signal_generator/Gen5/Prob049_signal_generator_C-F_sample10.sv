module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end
    else begin
        // Update wave based on current direction
        wave <= direction ? wave - 1'b1 : wave + 1'b1;
        
        // Update direction at boundaries
        if (wave == 5'b11111 && !direction) begin
            direction <= 1'b1;  // Switch to decrement at max
        end
        else if (wave == 5'b00000 && direction) begin
            direction <= 1'b0;  // Switch to increment at min
        end
    end
end

endmodule