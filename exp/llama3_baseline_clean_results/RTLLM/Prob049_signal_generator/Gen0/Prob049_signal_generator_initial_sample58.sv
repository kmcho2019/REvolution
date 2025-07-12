module signal_generator(
    input clk,
    input rst_n,
    output [4:0] wave
);

reg [4:0] wave_reg;
reg [0:0] state_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state_reg <= 0;
        wave_reg <= 0;
    end
    else begin
        case (state_reg)
            0: begin
                if (wave_reg == 31) begin
                    state_reg <= 1;
                    wave_reg <= wave_reg;
                end
                else begin
                    state_reg <= state_reg;
                    wave_reg <= wave_reg + 1;
                end
            end
            1: begin
                if (wave_reg == 0) begin
                    state_reg <= 0;
                    wave_reg <= wave_reg;
                end
                else begin
                    state_reg <= state_reg;
                    wave_reg <= wave_reg - 1;
                end
            end
            default: begin
                state_reg <= 0;
                wave_reg <= 0;
            end
        endcase
    end
end

assign wave = wave_reg;

endmodule