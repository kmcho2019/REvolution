module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_reg;
reg direction;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave_reg <= 0;
        direction <= 1; // 1 for increment, 0 for decrement
    end else begin
        if (direction) begin
            wave_reg <= wave_reg + 1;
            if (wave_reg == 31) begin
                direction <= 0;
            end
        end else begin
            wave_reg <= wave_reg - 1;
            if (wave_reg == 0) begin
                direction <= 1;
            end
        end
    end
end

assign wave = wave_reg;

endmodule