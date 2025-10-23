module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0=increment, 1=decrement

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end
    else begin
        if (direction) begin
            // Decrement phase
            wave <= wave - 1;
            if (wave == 5'b00001) begin
                direction <= 1'b0;  // Switch to increment
            end
        end
        else begin
            // Increment phase
            wave <= wave + 1;
            if (wave == 5'b11110) begin  // Compare before increment
                direction <= 1'b1;  // Switch to decrement
            end
        end
    end
end

endmodule