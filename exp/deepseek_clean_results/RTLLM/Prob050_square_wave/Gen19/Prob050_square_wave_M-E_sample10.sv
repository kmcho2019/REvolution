module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [8:0] phase_acc = 0;  // Extra bit for overflow detection
    
    // Clock gating - only update when freq is non-zero
    wire update_enable = (freq != 0);
    
    always @(posedge clk) begin
        if (freq == 0) begin
            phase_acc <= 0;
            wave_out <= 0;
        end else if (update_enable) begin
            phase_acc <= phase_acc + {1'b0, freq};
            wave_out <= phase_acc[8];  // MSB becomes square wave output
        end
    end

endmodule