module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] state; // state register to control waveform generation

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        state <= 0; // clear state register
        wave <= 0; // clear waveform register
    end else begin // normal operation
        case (state)
            0: begin // increment waveform
                wave <= wave + 1;
                if (wave == 31) begin // transition to decrement state
                    state <= 1;
                end
            end
            1: begin // decrement waveform
                wave <= wave - 1;
                if (wave == 0) begin // transition to increment state
                    state <= 0;
                end
            end
        endcase
    end
end

endmodule