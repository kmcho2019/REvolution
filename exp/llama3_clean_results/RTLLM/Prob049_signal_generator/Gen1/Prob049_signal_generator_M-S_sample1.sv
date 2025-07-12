module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 0;
        direction <= 1; // Initial direction is increment (1)
    end else begin
        if (direction) begin // Incrementing
            wave <= wave + 1;
            if (wave == 31) begin
                direction <= 0; // Change direction to decrement
            end
        end else begin // Decrementing
            wave <= wave - 1;
            if (wave == 0) begin
                direction <= 1; // Change direction to increment
            end
        end
    end
end

endmodule