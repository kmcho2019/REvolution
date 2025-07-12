module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [8:0] phase_acc = 0;  // Extra bit for overflow detection
    
    always @(posedge clk) begin
        phase_acc <= phase_acc + {1'b0, freq};  // Phase accumulation
        wave_out <= phase_acc[8];  // MSB becomes square wave output
    end

endmodule