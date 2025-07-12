module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_reg;
reg incr;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave_reg <= 0;
        incr <= 1;
    end else begin
        if (incr) begin
            if (wave_reg == 31) begin
                wave_reg <= wave_reg;
                incr <= 0;
            end else begin
                wave_reg <= wave_reg + 1;
            end
        end else begin
            if (wave_reg == 0) begin
                wave_reg <= wave_reg;
                incr <= 1;
            end else begin
                wave_reg <= wave_reg - 1;
            end
        end
    end
end

assign wave = wave_reg;

endmodule