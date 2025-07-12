module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [7:0] phase_accumulator;
    
    // The MSB of the phase accumulator is our square wave output
    assign wave_out = phase_accumulator[7];
    
    // Phase accumulator update logic
    always @(posedge clk) begin
        phase_accumulator <= phase_accumulator + freq;
    end

endmodule