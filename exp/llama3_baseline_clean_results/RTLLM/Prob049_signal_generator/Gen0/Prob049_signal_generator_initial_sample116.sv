module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] state; // state register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        state <= 0; // clear state register
        wave <= 0; // clear waveform register
    end else begin
        case (state)
            0: begin // incrementing state
                if (wave == 31) begin
                    state <= 1; // transition to decrementing state
                    wave <= 31; // hold waveform value
                end else begin
                    wave <= wave + 1; // increment waveform
                end
            end
            1: begin // decrementing state
                if (wave == 0) begin
                    state <= 0; // transition to incrementing state
                    wave <= 0; // hold waveform value
                end else begin
                    wave <= wave - 1; // decrement waveform
                end
            end
        endcase
    end
end

endmodule