module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] state;  // 1-bit register to store the state (0 or 1)
reg [4:0] wave_next;  // next value of the waveform

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // reset
        state <= 0;
        wave <= 0;
    end else begin
        case (state)
            0: begin
                wave_next = wave + 1;
                if (wave == 5'd31) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
            end
            1: begin
                wave_next = wave - 1;
                if (wave == 5'd0) begin
                    state <= 0;
                end else begin
                    state <= 1;
                end
            end
            default: begin
                state <= 0;
                wave_next = 0;
            end
        endcase
        wave <= wave_next;
    end
end

endmodule