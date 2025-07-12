module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [15:0] phase_accumulator;  // 16-bit for better frequency resolution

    always @(posedge clk) begin
        // Phase accumulator adds frequency value each cycle
        {wave_out, phase_accumulator} <= phase_accumulator + {8'b0, freq};
        
        // The MSB (wave_out) toggles when accumulator overflows
    end

endmodule