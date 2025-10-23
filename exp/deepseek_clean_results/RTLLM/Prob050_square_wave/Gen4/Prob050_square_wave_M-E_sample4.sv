module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    // 16-bit phase accumulator for better frequency resolution
    reg [15:0] phase_acc;
    
    // Phase increment value (scaled to use full accumulator range)
    wire [15:0] phase_inc = {freq, 8'b0};  // freq * 256
    
    always @(posedge clk) begin
        // Update phase accumulator
        phase_acc <= phase_acc + phase_inc;
        
        // Toggle output on phase overflow
        if (phase_acc + phase_inc < phase_acc) begin
            wave_out <= ~wave_out;
        end
    end

endmodule