module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Active-low reset
        wave <= 5'b0;
    end
    else begin
        // Determine direction based on current value
        // If at max (31), start decrementing
        // If at min (0), start incrementing
        // Otherwise continue in current direction
        wave <= (wave == 5'b11111) ? (wave - 1'b1) :
                (wave == 5'b00000) ? (wave + 1'b1) :
                (wave[4]) ? (wave - 1'b1) : (wave + 1'b1);
    end
end

endmodule