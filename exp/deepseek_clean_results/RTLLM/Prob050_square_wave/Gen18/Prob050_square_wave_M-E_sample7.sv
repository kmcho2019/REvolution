module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    // 16-bit phase accumulator for better frequency resolution
    reg [15:0] phase_acc = 0;
    
    always @(posedge clk) begin
        // Phase accumulation - automatically wraps around
        phase_acc <= phase_acc + {8'b0, freq};
        
        // Square wave output is the MSB of the accumulator
        wave_out <= phase_acc[15];
    end

endmodule