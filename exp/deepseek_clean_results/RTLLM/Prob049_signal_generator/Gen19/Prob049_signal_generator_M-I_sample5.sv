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
            // At minimum, start incrementing
            wave <= wave + 1'b1;
        end else if (&wave) begin
            // At maximum (all 1s), start decrementing
            wave <= wave - 1'b1;
        end else begin
            // Continue in current direction (MSB indicates direction)
            wave <= wave[4] ? (wave - 1'b1) : (wave + 1'b1);
        end
    end
end

endmodule