module square_wave(
    input clk,     // Clock signal
    input [7:0] freq,  // Frequency control
    output reg wave_out // Square wave output
);

reg [7:0] count;  // Counter register

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        // Reset count and toggle wave_out when count reaches freq - 1
        count <= 8'd0;
        wave_out <= ~wave_out;  // Toggle wave_out
    end else if (freq != 0) begin
        // Increment count if it hasn't reached freq - 1
        count <= count + 1'd1;
    end else begin
        // Do nothing if freq is 0
        count <= count;
    end
end

// Initialize wave_out to 0
initial begin
    wave_out = 1'b0;
end

endmodule