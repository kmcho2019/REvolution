module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_reg;
reg up;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave_reg <= 5'b00000;
        up <= 1'b1;
    end else begin
        if (up) begin
            wave_reg <= wave_reg + 1'b1;
            if (wave_reg == 5'b11111) begin
                up <= 1'b0;
            end
        end else begin
            wave_reg <= wave_reg - 1'b1;
            if (wave_reg == 5'b00000) begin
                up <= 1'b1;
            end
        end
    end
end

assign wave = wave_reg;

endmodule