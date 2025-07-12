module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

parameter MAX_VALUE = 5'd31;
parameter MIN_VALUE = 5'd0;

reg state_reg;
reg [4:0] wave_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state_reg <= 1'b0;
        wave_reg <= MIN_VALUE;
    end else begin
        if (state_reg == 1'b0) begin
            wave_reg <= (wave_reg == MAX_VALUE) ? MIN_VALUE : wave_reg + 1'd1;
            state_reg <= (wave_reg == MAX_VALUE) ? 1'b1 : 1'b0;
        end else begin
            wave_reg <= (wave_reg == MIN_VALUE) ? MAX_VALUE : wave_reg - 1'd1;
            state_reg <= (wave_reg == MIN_VALUE) ? 1'b0 : 1'b1;
        end
    end
end

assign wave = wave_reg;

endmodule