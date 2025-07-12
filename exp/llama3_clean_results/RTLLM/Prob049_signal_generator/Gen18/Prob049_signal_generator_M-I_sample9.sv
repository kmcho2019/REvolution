module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

parameter MAX_VALUE = 5'd31;

reg state_reg;
reg [4:0] wave_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state_reg <= 1'b0;
        wave_reg <= 5'd0;
    end else begin
        if (state_reg == 1'b0) begin
            if (wave_reg == MAX_VALUE) begin
                state_reg <= 1'b1;
                wave_reg <= MAX_VALUE;
            end else begin
                wave_reg <= wave_reg + 1'd1;
            end
        end else begin
            if (wave_reg == 5'd0) begin
                state_reg <= 1'b0;
                wave_reg <= 5'd0;
            end else begin
                wave_reg <= wave_reg - 1'd1;
            end
        end
    end
end

assign wave = wave_reg;

endmodule