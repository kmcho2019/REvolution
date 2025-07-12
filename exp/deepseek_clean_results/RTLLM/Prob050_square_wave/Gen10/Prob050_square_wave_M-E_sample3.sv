module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    // 16-bit phase accumulator (8 more bits than input for fractional resolution)
    reg [15:0] phase_acc;
    
    // Output is MSB of accumulator (naturally toggles at desired frequency)
    assign wave_out = phase_acc[15];
    
    always @(posedge clk) begin
        // Phase accumulator update (automatically handles freq=0 case)
        phase_acc <= phase_acc + {8'b0, freq};
    end

endmodule