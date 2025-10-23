module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] state; // state register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        state <= 0; // reset state to 0
        wave <= 0; // reset waveform to 0
    end else begin
        case (state)
            0: begin
                wave <= wave + 1; // increment waveform
                if (wave == 31) begin // check if waveform has reached 31
                    state <= 1; // transition to state 1
                end
            end
            1: begin
                wave <= wave - 1; // decrement waveform
                if (wave == 0) begin // check if waveform has reached 0
                    state <= 0; // transition back to state 0
                end
            end
            default: begin
                state <= 0; // default state
                wave <= 0; // default waveform
            end
        endcase
    end
end

endmodule