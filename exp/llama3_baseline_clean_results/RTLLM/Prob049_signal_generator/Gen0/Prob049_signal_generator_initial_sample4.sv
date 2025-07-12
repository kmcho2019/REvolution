module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_reg;
reg state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        wave_reg <= 0;
    end else begin
        case (state)
            0: begin
                wave_reg <= wave_reg + 1;
                if (wave_reg == 5'd31) begin
                    state <= 1;
                end
            end
            1: begin
                wave_reg <= wave_reg - 1;
                if (wave_reg == 5'd0) begin
                    state <= 0;
                end
            end
            default: begin
                state <= 0;
                wave_reg <= 0;
            end
        endcase
    end
end

assign wave = wave_reg;

endmodule