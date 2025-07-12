module square_wave(
    input clk,  // Clock signal
    input [7:0] freq,  // Frequency control
    output reg wave_out  // Square wave output signal
    );

reg [7:0] count;  // Counter register
reg [7:0] phase;  // Phase register

always @(posedge clk) begin
    count <= count + 1;
    if (count >= freq) begin
        count <= 0;
        phase <= ~phase;  // Toggle phase
    end
end

always @(posedge clk) begin
    if (phase) begin
        wave_out <= 1;
    end else begin
        wave_out <= 0;
    end
end

initial begin
    count <= 0;
    phase <= 0;  // Initialize phase to 0
    wave_out <= 0;  // Initialize wave_out to 0
end

endmodule