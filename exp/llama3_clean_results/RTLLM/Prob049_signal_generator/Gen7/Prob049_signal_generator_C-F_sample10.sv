module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_reg;
reg [0:0] state;
reg clk_enable;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave_reg <= 0;
        state <= 0;
        clk_enable <= 1;
    end else if (clk_enable) begin
        case (state)
            0: begin
                if (wave_reg == 31) begin
                    state <= 1;
                end
                wave_reg <= (wave_reg == 31) ? 31 : wave_reg + 1;
            end
            1: begin
                if (wave_reg == 0) begin
                    state <= 0;
                end
                wave_reg <= (wave_reg == 0) ? 0 : wave_reg - 1;
            end
        endcase
    end
end

assign wave = wave_reg;

endmodule