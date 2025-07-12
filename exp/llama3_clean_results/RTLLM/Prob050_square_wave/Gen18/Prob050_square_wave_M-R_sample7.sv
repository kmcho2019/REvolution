module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Counter register

// Increment the counter on each rising edge of the clk
always @(posedge clk) begin
    if (count == freq - 1) begin
        count <= 0;  // Reset the counter when it reaches freq - 1
        wave_out <= ~wave_out;  // Toggle the output square wave signal
    end else begin
        count <= count + 1;  // Increment the counter
    end
end

endmodule