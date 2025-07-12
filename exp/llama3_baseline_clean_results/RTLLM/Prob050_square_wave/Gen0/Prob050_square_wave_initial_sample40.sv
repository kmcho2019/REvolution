module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);
reg [7:0] count; // Counter register

always @(posedge clk) begin
    if (count == (freq - 1)) begin // Check if count has reached freq - 1
        count <= 0; // Reset count to 0
        wave_out <= ~wave_out; // Toggle wave_out
    end else begin
        count <= count + 1; // Increment count by 1
    end
end

initial begin
    count = 0; // Initialize count to 0
    wave_out = 0; // Initialize wave_out to 0
end

endmodule