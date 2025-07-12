module signal_generator (
    input clk,
    input rst_n,
    output [4:0] wave
);

reg [4:0] wave_reg;
reg state;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        wave_reg <= 0;
    end else begin
        case (state)
            0: begin
                if (wave_reg == 5'd31) begin
                    state <= 1;
                    wave_reg <= wave_reg - 1;
                end else begin
                    state <= state;
                    wave_reg <= wave_reg + 1;
                end
            end
            1: begin
                if (wave_reg == 5'd0) begin
                    state <= 0;
                    wave_reg <= wave_reg + 1;
                end else begin
                    state <= state;
                    wave_reg <= wave_reg - 1;
                end
            end
        endcase
    end
end

assign wave = wave_reg;

endmodule