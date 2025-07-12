module signal_generator (
    input clk,
    input rst_n,
    output [4:0] wave
);

reg [4:0] wave_reg;
reg [0:0] state_reg;
reg [4:0] wave_next;
reg [0:0] state_next;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state_reg <= 0;
        wave_reg <= 0;
    end else begin
        state_reg <= state_next;
        wave_reg <= wave_next;
    end
end

always @(*) begin
    wave_next = wave_reg;
    state_next = state_reg;

    case (state_reg)
        0: begin
            wave_next = wave_reg + 1;
            if (wave_reg == 5'd31) begin
                state_next = 1;
            end
        end
        1: begin
            wave_next = wave_reg - 1;
            if (wave_reg == 5'd0) begin
                state_next = 0;
            end
        end
    endcase
end

assign wave = wave_reg;

endmodule