module square_wave(
    input           clk,       // Clock signal
    input   [7:0]   freq,      // Frequency control
    output  reg     wave_out   // Square wave output signal
);

reg [7:0] count;               // Counter register

always @ (posedge clk) begin
    if (count == (freq - 1)) begin
        count <= 8'd0;         // Reset count when it reaches freq - 1
        wave_out <= ~wave_out; // Toggle wave_out
    end else begin
        count <= count + 1;    // Increment count on each clock cycle
    end
end

endmodule