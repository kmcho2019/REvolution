module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [1:0] state;  // State register to control waveform generation

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        state <= 0;    // Clear state register to 0
        wave <= 0;     // Clear wave register to 0
    end else begin
        case (state)
            0: begin  // Increment waveform
                wave <= wave + 1;
                if (wave == 31) begin  // Transition to decrement state when wave reaches 31
                    state <= 1;
                end
            end
            1: begin  // Decrement waveform
                wave <= wave - 1;
                if (wave == 0) begin  // Transition to increment state when wave reaches 0
                    state <= 0;
                end
            end
        endcase
    end
end

endmodule