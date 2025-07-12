module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 1 = increment, 0 = decrement

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        direction <= 1'b1;  // Start by incrementing
    end
    else begin
        // Update wave based on direction
        wave <= direction ? wave + 1 : wave - 1;
        
        // Toggle direction at boundaries
        if (wave == 5'b11111 || wave == 5'b00000)
            direction <= ~direction;
    end
end

endmodule