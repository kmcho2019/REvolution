module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [8:0] phase_acc = 0;  // 9-bit to detect overflow
    wire phase_overflow = phase_acc[8];
    
    always @(posedge clk) begin
        if (freq == 0) begin
            wave_out <= 1'b0;  // Special case: force output low
        end else begin
            // Phase accumulator update
            {phase_overflow, phase_acc[7:0]} <= phase_acc + {1'b0, freq};
            
            // Toggle output on overflow
            if (phase_overflow) begin
                wave_out <= ~wave_out;
            end
        end
    end

endmodule