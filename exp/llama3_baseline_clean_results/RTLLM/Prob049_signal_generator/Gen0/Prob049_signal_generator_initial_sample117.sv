module signal_generator(
    input  clk,
    input  rst_n,
    output [4:0] wave
);

reg [4:0] wave_reg; // register to hold the waveform value
reg       state_reg; // register to hold the state (0: increment, 1: decrement)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        state_reg <= 0; // clear state register to 0
        wave_reg <= 0; // clear waveform register to 0
    end else begin
        case (state_reg)
            0: begin // incrementing phase
                if (wave_reg == 5'd31) begin // check if waveform reached 31
                    state_reg <= 1; // transition to decrementing phase
                    wave_reg <= 5'd31; // hold waveform value at 31
                end else begin
                    wave_reg <= wave_reg + 1; // increment waveform value
                end
            end
            1: begin // decrementing phase
                if (wave_reg == 5'd0) begin // check if waveform reached 0
                    state_reg <= 0; // transition to incrementing phase
                    wave_reg <= 5'd0; // hold waveform value at 0
                end else begin
                    wave_reg <= wave_reg - 1; // decrement waveform value
                end
            end
            default: begin // default case
                state_reg <= 0; // default to incrementing phase
                wave_reg <= 0; // default to waveform value 0
            end
        endcase
    end
end

assign wave = wave_reg; // output the waveform value

endmodule