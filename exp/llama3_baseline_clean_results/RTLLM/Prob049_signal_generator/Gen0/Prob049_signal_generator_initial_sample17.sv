module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);
    
    reg [0:0] state;  // 1-bit state register

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 0;  // Reset state to 0 on active-low reset
            wave <= 0;   // Reset waveform to 0 on active-low reset
        end else begin
            case (state)
                0: begin
                    if (wave == 31) begin
                        state <= 1;  // Transition to state 1 when waveform reaches 31
                        wave <= wave; // Hold waveform value
                    end else begin
                        wave <= wave + 1;  // Increment waveform by 1
                    end
                end
                1: begin
                    if (wave == 0) begin
                        state <= 0;  // Transition to state 0 when waveform reaches 0
                        wave <= wave; // Hold waveform value
                    end else begin
                        wave <= wave - 1;  // Decrement waveform by 1
                    end
                end
                default: begin
                    state <= 0;  // Default state is 0
                    wave <= 0;   // Default waveform value is 0
                end
            endcase
        end
    end

endmodule