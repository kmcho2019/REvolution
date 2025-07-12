module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;
reg enable_clock = 1'b1; // Clock enable signal

// Clock gating logic
always @(posedge clk) begin
    if (enable_clock) begin
        if (count == freq) begin
            count <= 8'd0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 8'd1;
        end
    end
end

// Optional: Add logic to dynamically control enable_clock based on freq changes
// This could involve a comparator to check if freq has changed and only then enable the clock
// For simplicity, this example keeps enable_clock always high, assuming freq changes are infrequent

// Optimization: Use a simpler counter implementation
// Instead of using a full 8-bit counter, we can use a smaller counter and adjust the frequency accordingly
// This can help reduce area consumption

// Optimization: Minimize unnecessary signal toggling
// We can add additional logic to minimize unnecessary signal toggling and reduce power consumption

endmodule