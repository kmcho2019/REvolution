module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_reg;
reg state_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave_reg <= 5'd0;
        state_reg <= 1'b0;
    end else begin
        if (state_reg == 1'b0) begin
            wave_reg <= (wave_reg == 5'd31) ? 5'd31 : wave_reg + 1'd1;
            state_reg <= (wave_reg == 5'd31) ? 1'b1 : 1'b0;
        end else begin
            wave_reg <= (wave_reg == 5'd0) ? 5'd0 : wave_reg - 1'd1;
            state_reg <= (wave_reg == 5'd0) ? 1'b0 : 1'b1;
        end
    end
end

assign wave = wave_reg;

endmodule