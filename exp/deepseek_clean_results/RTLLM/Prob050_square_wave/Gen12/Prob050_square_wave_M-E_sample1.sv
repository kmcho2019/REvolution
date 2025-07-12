module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    // 16-bit accumulator allows for finer frequency control
    reg [15:0] phase_accumulator = 0;
    
    always @(posedge clk) begin
        // Phase accumulation - naturally wraps around
        phase_accumulator <= phase_accumulator + {8'b0, freq};
        
        // Square wave output is simply the MSB of the accumulator
        wave_out <= phase_accumulator[15];
    end

endmodule