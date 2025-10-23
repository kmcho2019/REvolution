module square_wave(
    input clk,  // Clock signal
    input [7:0] freq,  // Frequency control
    output reg wave_out  // Square wave output signal
    );

reg [7:0] count;  // Counter register
reg wave_out_next;  // Next value of wave_out

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        count <= 0;
        wave_out_next <= ~wave_out;  // Toggle wave_out
    end else begin
        count <= count + 1;
        wave_out_next <= wave_out;  // Hold wave_out value
    end
end

always @(posedge clk) begin
    wave_out <= wave_out_next;  // Update wave_out
end

initial begin
    count <= 0;
    wave_out <= 0;  // Initialize wave_out to 0
end

endmodule