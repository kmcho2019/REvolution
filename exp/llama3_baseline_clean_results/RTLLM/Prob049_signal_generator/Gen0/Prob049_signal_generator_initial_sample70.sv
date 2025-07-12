module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] state;  // 1-bit state register
reg [4:0] wave_next;  // next value of waveform

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;  // reset state to 0
        wave <= 0;   // reset waveform to 0
    end else begin
        case (state)
            0: begin
                wave_next = wave + 1;
                if (wave == 5'd31) begin
                    state <= 1;  // transition to state 1 when wave reaches 31
                end else begin
                    state <= 0;  // stay in state 0
                end
            end
            1: begin
                wave_next = wave - 1;
                if (wave == 0) begin
                    state <= 0;  // transition to state 0 when wave reaches 0
                end else begin
                    state <= 1;  // stay in state 1
                end
            end
            default: begin
                state <= 0;  // default state is 0
                wave_next = 0;  // default waveform is 0
            end
        endcase
        wave <= wave_next;  // update waveform
    end
end

endmodule