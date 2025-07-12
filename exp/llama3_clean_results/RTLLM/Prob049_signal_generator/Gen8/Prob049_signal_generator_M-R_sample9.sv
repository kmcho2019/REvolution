module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_reg;
reg [0:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave_reg <= 0;
        state <= 0;
    end else begin
        case (state)
            1'b0: begin
                if (wave_reg == 5'd31) begin
                    wave_reg <= wave_reg;
                    state <= 1'b1;
                end else begin
                    wave_reg <= wave_reg + 1'b1;
                    state <= 1'b0;
                end
            end
            1'b1: begin
                if (wave_reg == 5'd0) begin
                    wave_reg <= wave_reg;
                    state <= 1'b0;
                end else begin
                    wave_reg <= wave_reg - 1'b1;
                    state <= 1'b1;
                end
            end
        endcase
    end
end

assign wave = wave_reg;

endmodule