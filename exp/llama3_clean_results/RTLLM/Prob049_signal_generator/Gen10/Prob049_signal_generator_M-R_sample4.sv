module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_reg;
reg direction; // 0: incrementing, 1: decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave_reg <= 0;
        direction <= 0;
    end else begin
        if (direction == 0) begin
            if (wave_reg == 31) begin
                direction <= 1;
            end
            wave_reg <= (wave_reg == 31) ? 31 : wave_reg + 1;
        end else begin
            if (wave_reg == 0) begin
                direction <= 0;
            end
            wave_reg <= (wave_reg == 0) ? 0 : wave_reg - 1;
        end
    end
end

assign wave = wave_reg;

endmodule