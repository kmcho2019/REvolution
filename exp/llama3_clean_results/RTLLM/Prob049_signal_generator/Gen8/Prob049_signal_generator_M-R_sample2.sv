module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_reg;
reg state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave_reg <= 0;
        state <= 0;
    end else begin
        if (state == 0) begin
            wave_reg <= (wave_reg == 31) ? 31 : wave_reg + 1;
            if (wave_reg == 31) begin
                state <= 1;
            end
        end else begin
            wave_reg <= (wave_reg == 0) ? 0 : wave_reg - 1;
            if (wave_reg == 0) begin
                state <= 0;
            end
        end
    end
end

assign wave = wave_reg;

endmodule