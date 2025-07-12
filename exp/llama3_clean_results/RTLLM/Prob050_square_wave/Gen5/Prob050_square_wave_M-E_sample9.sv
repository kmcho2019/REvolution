module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [15:0] phase_accumulator = 16'd0;
reg [15:0] threshold = 16'd0;

always @(posedge clk) begin
    phase_accumulator <= phase_accumulator + 16'd1;
    threshold <= 16'd65535 / freq;
    
    if (phase_accumulator >= threshold) begin
        wave_out <= ~wave_out;
        phase_accumulator <= 16'd0;
    end
end

endmodule