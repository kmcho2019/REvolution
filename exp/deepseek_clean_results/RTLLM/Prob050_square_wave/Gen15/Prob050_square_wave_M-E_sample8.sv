module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    // 16-bit phase accumulator (extra bits for better frequency resolution)
    reg [15:0] phase_acc = 0;
    
    // Scale factor to convert 8-bit freq to phase increment
    // This determines the frequency range
    localparam PHASE_SCALE = 8'd16;
    
    always @(posedge clk) begin
        if (freq == 0) begin
            wave_out <= 1'b0;
            phase_acc <= 0;
        end else begin
            // Accumulate phase (automatically rolls over)
            phase_acc <= phase_acc + {freq, PHASE_SCALE};
            
            // MSB becomes our square wave output
            wave_out <= phase_acc[15];
        end
    end

endmodule