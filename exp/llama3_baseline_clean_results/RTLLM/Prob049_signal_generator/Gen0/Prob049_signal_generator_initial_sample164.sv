module signal_generator(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [4:0] wave // 5-bit output waveform signal
);
reg [0:0] state; // 1-bit state register

// Initialize the state and waveform registers
initial begin
    state = 0;
    wave = 0;
end

// Update the state and waveform registers on the positive edge of the clock signal or the negative edge of the reset signal
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= 0; // Clear the state register to 0
        wave <= 0; // Clear the waveform register to 0
    end else begin
        case (state)
            0: begin // Incrementing state
                wave <= wave + 1; // Increment the waveform by 1
                if (wave == 31) begin // Check if the waveform reaches 31
                    state <= 1; // Transition to the decrementing state
                end
            end
            1: begin // Decrementing state
                wave <= wave - 1; // Decrement the waveform by 1
                if (wave == 0) begin // Check if the waveform reaches 0
                    state <= 0; // Transition back to the incrementing state
                end
            end
            default: begin
                state <= 0; // Default state
                wave <= 0; // Default waveform value
            end
        endcase
    end
end

endmodule