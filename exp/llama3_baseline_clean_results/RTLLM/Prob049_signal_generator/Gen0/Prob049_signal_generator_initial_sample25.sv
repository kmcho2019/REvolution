module signal_generator(
    input clk,
    input rst_n,
    output [4:0] wave
);

reg [4:0] wave_reg; // register to hold the waveform value
reg state_reg;      // register to hold the state value

assign wave = wave_reg; // assign the output wave to the internal register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        state_reg <= 0;
        wave_reg <= 0;
    end else begin
        case (state_reg)
            0: begin // incrementing state
                if (wave_reg == 31) begin
                    state_reg <= 1;
                    wave_reg <= wave_reg;
                end else begin
                    state_reg <= state_reg;
                    wave_reg <= wave_reg + 1;
                end
            end
            1: begin // decrementing state
                if (wave_reg == 0) begin
                    state_reg <= 0;
                    wave_reg <= wave_reg;
                end else begin
                    state_reg <= state_reg;
                    wave_reg <= wave_reg - 1;
                end
            end
        endcase
    end
end

endmodule