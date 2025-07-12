module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction; // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        // Update wave based on current direction
        if (direction) begin
            wave <= wave - 1;
        end else begin
            wave <= wave + 1;
        end
        
        // Automatic direction switching at boundaries
        if (wave == 5'd30 && !direction) begin
            direction <= 1'b1; // Switch to decrement at 31 (next cycle)
        end else if (wave == 5'd1 && direction) begin
            direction <= 1'b0; // Switch to increment at 0 (next cycle)
        end
    end
end

endmodule