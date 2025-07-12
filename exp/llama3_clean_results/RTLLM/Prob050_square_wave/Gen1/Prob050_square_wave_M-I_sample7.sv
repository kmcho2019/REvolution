module square_wave(
    input clk,  // Clock signal
    input [7:0] freq,  // Frequency control
    output reg wave_out  // Square wave output signal
    );

reg [7:0] count;  // Counter register
reg enable_count;  // Clock gating signal

always @(posedge clk) begin
    if (enable_count) begin
        if (count == (freq - 1)) begin
            count = 0;
            wave_out = ~wave_out;  // Toggle wave_out
            enable_count = 0;
        end else begin
            count = count + 1;
        end
    end else if (wave_out == 0) begin
        enable_count = 1;
    end
end

initial begin
    count = 0;
    wave_out = 0;  // Initialize wave_out to 0
    enable_count = 1;
end

endmodule