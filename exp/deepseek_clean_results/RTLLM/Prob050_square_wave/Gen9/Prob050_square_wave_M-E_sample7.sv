module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    // Phase accumulator (16 bits for better resolution)
    reg [15:0] phase_acc = 0;
    
    // Phase increment value (maps input frequency to phase steps)
    wire [15:0] phase_inc = {freq, 8'b0};  // freq * 256
    
    always @(posedge clk) begin
        phase_acc <= phase_acc + phase_inc;
        wave_out <= phase_acc[15];  // MSB gives square wave output
    end

endmodule