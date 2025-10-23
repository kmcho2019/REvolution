module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
    end else begin
        if (wave == 5'b0) begin
            wave <= wave + 1'b1;  // Start incrementing from 0
        end else if (wave == 5'b11111) begin
            wave <= wave - 1'b1;  // Start decrementing from 31
        end else begin
            // Continue in current direction
            wave <= wave[4] ? wave - 1'b1 : wave + 1'b1;
        end
    end
end

endmodule