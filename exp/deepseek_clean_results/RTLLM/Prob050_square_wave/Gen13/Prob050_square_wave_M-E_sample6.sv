module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [15:0] phase_accumulator;
    
    // The square wave output is the MSB of the phase accumulator
    assign wave_out = phase_accumulator[15];
    
    // Phase accumulator update logic
    always @(posedge clk) begin
        phase_accumulator <= phase_accumulator + {8'b0, freq};
    end

endmodule