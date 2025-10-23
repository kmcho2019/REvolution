module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_reg;
reg state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave_reg <= 5'd0;
        state <= 1'b0;
    end else begin
        case (state)
            1'b0: begin
                wave_reg <= (wave_reg == 5'd31)? 5'd31 : wave_reg + 1'd1;
                if (wave_reg == 5'd31) begin
                    state <= 1'b1;
                end
            end
            1'b1: begin
                wave_reg <= (wave_reg == 5'd0)? 5'd0 : wave_reg - 1'd1;
                if (wave_reg == 5'd0) begin
                    state <= 1'b0;
                end
            end
        endcase
    end
end

assign wave = wave_reg;

endmodule