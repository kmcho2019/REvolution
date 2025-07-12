module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 for increment (shift left), 1 for decrement (shift right)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b00000;
        direction <= 0;
    end
    else begin
        // Check for direction change conditions
        if (direction == 0 && wave == 5'b11110) begin
            direction <= 1;  // Switch to decrement at max-1 (to catch all 1's case)
        end
        else if (direction == 1 && wave == 5'b00001) begin
            direction <= 0;  // Switch to increment at min+1 (to catch all 0's case)
        end
        
        // Apply shift operation based on direction
        if (direction == 0) begin
            // Increment mode: shift left with 0 fill
            wave <= {wave[3:0], 1'b0};
        end
        else begin
            // Decrement mode: shift right with 1 fill
            wave <= {1'b1, wave[4:1]};
        end
    end
end

endmodule