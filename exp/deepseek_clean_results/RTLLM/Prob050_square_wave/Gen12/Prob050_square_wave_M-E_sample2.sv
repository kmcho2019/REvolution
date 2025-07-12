module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    // 16-bit phase accumulator for better frequency resolution
    reg [15:0] phase_acc = 0;
    
    // Phase increment is frequency value shifted left for scaling
    wire [15:0] phase_inc = {freq, 8'b0};
    
    always @(posedge clk) begin
        if (freq == 0) begin
            // Special case: zero frequency means constant low
            wave_out <= 1'b0;
            phase_acc <= 0;
        end else begin
            // Normal operation: accumulate phase
            phase_acc <= phase_acc + phase_inc;
            // Output is MSB of accumulator (natural square wave)
            wave_out <= phase_acc[15];
        end
    end

endmodule