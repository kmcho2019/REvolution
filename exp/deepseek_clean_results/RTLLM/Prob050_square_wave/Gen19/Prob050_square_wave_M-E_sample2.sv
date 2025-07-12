module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    // 16-bit phase accumulator for better frequency resolution
    reg [15:0] phase_acc = 0;
    reg prev_msb = 0;

    always @(posedge clk) begin
        if (freq == 0) begin
            wave_out <= 1'b0;
            phase_acc <= 0;
            prev_msb <= 0;
        end else begin
            // Phase accumulation
            phase_acc <= phase_acc + {8'b0, freq};
            
            // Edge detection on MSB
            prev_msb <= phase_acc[15];
            
            // Toggle output on MSB edge
            if (prev_msb != phase_acc[15]) begin
                wave_out <= ~wave_out;
            end
        end
    end

endmodule