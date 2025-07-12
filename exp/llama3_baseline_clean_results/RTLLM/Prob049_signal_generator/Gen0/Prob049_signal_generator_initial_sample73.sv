module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_reg;
reg [0:0] state_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state_reg <= 0;
        wave_reg <= 0;
    end else begin
        case (state_reg)
            0: begin
                wave_reg <= wave_reg + 1;
                if (wave_reg == 31) begin
                    state_reg <= 1;
                end else begin
                    state_reg <= 0;
                end
            end
            1: begin
                wave_reg <= wave_reg - 1;
                if (wave_reg == 0) begin
                    state_reg <= 0;
                end else begin
                    state_reg <= 1;
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