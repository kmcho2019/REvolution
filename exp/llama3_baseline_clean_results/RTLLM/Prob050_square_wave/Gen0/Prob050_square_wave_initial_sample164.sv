module square_wave(
    input clk,
    input [7:0] freq,
    output wave_out
);

reg [7:0] count; // Internal counter register
reg wave_out;    // Output square wave signal

always @(posedge clk) begin
    if (count == freq - 1) begin // Check if count has reached freq - 1
        count <= 0;              // Reset count
        wave_out <= ~wave_out;   // Toggle wave_out
    end else begin
        count <= count + 1;      // Increment count if not at freq - 1
    end
end

endmodule