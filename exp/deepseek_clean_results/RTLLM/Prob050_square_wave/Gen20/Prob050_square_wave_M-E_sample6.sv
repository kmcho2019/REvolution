module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] phase_acc = 0;

    always @(posedge clk) begin
        if (freq != 0) begin
            phase_acc <= phase_acc + freq;
        end
        wave_out <= phase_acc[7];  // MSB becomes square wave output
    end

endmodule