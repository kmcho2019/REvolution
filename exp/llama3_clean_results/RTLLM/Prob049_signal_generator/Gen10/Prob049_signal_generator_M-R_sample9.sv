module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] state;
reg [4:0] wave_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
    end else begin
        case (state)
            0: begin
                if (wave_reg == 31) begin
                    state <= 1;
                end
            end
            1: begin
                if (wave_reg == 0) begin
                    state <= 0;
                end
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave_reg <= 0;
    end else begin
        case (state)
            0: begin
                wave_reg <= (wave_reg == 31) ? 31 : wave_reg + 1;
            end
            1: begin
                wave_reg <= (wave_reg == 0) ? 0 : wave_reg - 1;
            end
        endcase
    end
end

assign wave = wave_reg;

endmodule