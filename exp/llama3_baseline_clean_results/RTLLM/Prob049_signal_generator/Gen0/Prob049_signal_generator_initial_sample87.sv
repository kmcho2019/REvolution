module signal_generator(
    input clk,        // Clock signal
    input rst_n,      // Active-low reset signal
    output reg [4:0] wave  // 5-bit output waveform signal
);
    reg [0:0] state;  // Register to control the state of the waveform generation

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin  // Reset condition
            state <= 0;    // Clear the state register
            wave <= 0;     // Clear the waveform register
        end else begin
            case (state)
                0: begin
                    if (wave == 5'd31) begin  // Check if waveform has reached 31
                        state <= 1;            // Transition to state 1
                        wave <= wave - 1;     // Decrement waveform
                    end else begin
                        wave <= wave + 1;     // Increment waveform
                    end
                end
                1: begin
                    if (wave == 5'd0) begin   // Check if waveform has reached 0
                        state <= 0;            // Transition to state 0
                        wave <= wave + 1;     // Increment waveform
                    end else begin
                        wave <= wave - 1;     // Decrement waveform
                    end
                end
                default: state <= 0;           // Default state
            endcase
        end
    end
endmodule