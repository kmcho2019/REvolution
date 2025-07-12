module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] phase;
reg [4:0] wave_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        phase <= 0;
        wave_reg <= 0;
    end else begin
        phase <= phase + 1;
        if (phase < 16) begin
            wave_reg <= wave_reg + 1;
        end else if (phase >= 16 && phase < 32) begin
            wave_reg <= wave_reg - 1;
        end else begin
            phase <= 0;
        end
    end
end

assign wave = wave_reg;

endmodule