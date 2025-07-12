module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    // Phase accumulator (16-bit for better frequency resolution)
    reg [15:0] phase_acc = 0;
    
    // Frequency Tuning Word calculation (FTW = (freq << 8) for 8-bit input)
    wire [15:0] ftw = {freq, 8'b0};
    
    always @(posedge clk) begin
        phase_acc <= phase_acc + ftw;
        wave_out <= phase_acc[15]; // MSB becomes square wave output
    end

endmodule