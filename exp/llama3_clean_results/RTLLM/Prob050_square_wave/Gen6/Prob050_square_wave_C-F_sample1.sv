module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

localparam bit_width = 8;  // Determine the counter's bit width based on the required frequency range

reg [bit_width-1:0] count = {bit_width{1'b0}};  // Initialize the counter

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        count <= {bit_width{1'b0}};  // Reset count to zero
        wave_out <= ~wave_out;  // Toggle wave_out
    end else begin
        count <= count + 1;  // Increment count
    end
end

// Initialize wave_out to 0
initial begin
    wave_out <= 0;
end

endmodule