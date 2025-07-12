module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] state; // 1-bit state register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active-low reset
        state <= 0;
        wave <= 0;
    end else begin
        case (state)
            0: begin // Increment waveform
                if (wave == 5'd31) begin // Check if waveform reached maximum value
                    state <= 1;
                    wave <= 5'd31;
                end else begin
                    wave <= wave + 1;
                end
            end
            1: begin // Decrement waveform
                if (wave == 5'd0) begin // Check if waveform reached minimum value
                    state <= 0;
                    wave <= 5'd0;
                end else begin
                    wave <= wave - 1;
                end
            end
        endcase
    end
end

endmodule