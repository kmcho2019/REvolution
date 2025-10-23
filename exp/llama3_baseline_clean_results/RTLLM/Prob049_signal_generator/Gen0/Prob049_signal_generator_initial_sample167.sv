module signal_generator (
    input clk,         // Clock signal
    input rst_n,       // Active-low reset signal
    output reg [4:0] wave  // 5-bit output waveform signal
);

reg [0:0] state;  // Register to control the state of the waveform generation

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // On reset
        state <= 0;   // Clear state register to 0
        wave <= 0;     // Clear waveform register to 0
    end else begin
        case (state)
            0: begin  // If state is 0, increment waveform
                wave <= wave + 1;
                if (wave == 31) begin  // If waveform reaches 31, transition state to 1
                    state <= 1;
                end
            end
            1: begin  // If state is 1, decrement waveform
                wave <= wave - 1;
                if (wave == 0) begin  // If waveform reaches 0, transition state back to 0
                    state <= 0;
                end
            end
            default: begin
                state <= 0;  // Default state
                wave <= 0;
            end
        endcase
    end
end

endmodule