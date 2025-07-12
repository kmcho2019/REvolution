module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Counter register
reg temp_wave_out;  // Temporary register to store the inverted value of wave_out

always @(posedge clk) begin
    if (count == freq) begin
        count <= 8'd0;  // Reset count
        temp_wave_out <= ~wave_out;  // Toggle wave_out
    end else begin
        count <= count + 8'd1;  // Increment count
    end
end

always @(*) begin
    wave_out <= temp_wave_out;  // Update wave_out
end

endmodule