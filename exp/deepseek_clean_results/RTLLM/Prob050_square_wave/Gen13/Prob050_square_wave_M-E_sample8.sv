module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    // 16-bit phase accumulator (for better frequency resolution)
    reg [15:0] phase_acc;
    
    // Phase accumulator update
    always @(posedge clk) begin
        phase_acc <= phase_acc + {8'b0, freq};
    end
    
    // Square wave output is the MSB of the accumulator
    assign wave_out = phase_acc[15];

endmodule