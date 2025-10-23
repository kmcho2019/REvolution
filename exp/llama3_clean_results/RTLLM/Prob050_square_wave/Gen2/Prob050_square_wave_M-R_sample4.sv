module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Counter register
reg [7:0] next_count;  // Next counter value

always @(posedge clk) begin
    count <= next_count;
end

always @(*) begin
    if (count == (freq - 1)) begin
        next_count = 0;  // Reset count
        wave_out = ~wave_out;  // Toggle wave_out
    end else begin
        next_count = count + 1;  // Increment count
    end
end

initial begin
    count = 0;
    wave_out = 0;
end

endmodule