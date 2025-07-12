module signal_generator(
    input clk,
    input rst_n,
    output [4:0] wave
);

reg [4:0] wave_reg;
reg [0:0] state_reg;
reg [4:0] wave_next;
reg [0:0] state_next;

assign wave = wave_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state_reg <= 0;
        wave_reg <= 0;
    end else begin
        state_reg <= state_next;
        wave_reg <= wave_next;
    end
end

always @ (*) begin
    case (state_reg)
        0: begin
            wave_next = wave_reg + 1;
            if (wave_reg == 31) begin
                state_next = 1;
            end else begin
                state_next = 0;
            end
        end
        1: begin
            wave_next = wave_reg - 1;
            if (wave_reg == 0) begin
                state_next = 0;
            end else begin
                state_next = 1;
            end
        end
        default: begin
            state_next = 0;
            wave_next = 0;
        end
    endcase
end

endmodule