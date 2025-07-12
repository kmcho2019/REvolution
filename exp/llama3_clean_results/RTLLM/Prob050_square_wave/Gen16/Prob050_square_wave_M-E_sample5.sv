module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Counter register
reg [7:0] accumulator;  // Accumulator register

// Initialize wave_out, count, and accumulator
initial begin
    wave_out = 1'b0;
    count = 8'b0;
    accumulator = 8'b0;
end

// Counter and accumulator operation
always @(posedge clk) begin
    count <= count + 1;
    if (count == freq - 1) begin
        wave_out <= ~wave_out;  // Toggle wave_out
        count <= 8'b0;  // Reset count
    end
    accumulator <= accumulator + 1;  // Increment accumulator
    if (accumulator == freq) begin
        accumulator <= 8'b0;  // Reset accumulator
    end
end

endmodule