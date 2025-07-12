module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [1:0] state; // register to control the state of the waveform generation

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // On reset, clear the state and wave registers
        state <= 2'b00;
        wave <= 5'b00000;
    end else begin
        case (state)
            2'b00: begin
                // If the state is 0, increment the waveform by 1
                wave <= wave + 5'b00001;
                if (wave == 5'b11111) begin
                    // If the waveform reaches 31, transition the state to 1
                    state <= 2'b01;
                end
            end
            2'b01: begin
                // If the state is 1, decrement the waveform by 1
                wave <= wave - 5'b00001;
                if (wave == 5'b00000) begin
                    // If the waveform reaches 0, transition the state back to 0
                    state <= 2'b00;
                end
            end
            default: begin
                state <= 2'b00; // Default state is 0
            end
        endcase
    end
end

endmodule