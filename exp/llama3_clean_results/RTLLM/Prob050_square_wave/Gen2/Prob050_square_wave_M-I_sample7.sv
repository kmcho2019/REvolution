module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Counter register
reg enable_count;  // Clock gating signal

// Generate clock gating signal
always @(posedge clk) begin
    if (count == (freq - 1)) begin
        enable_count <= 1'b0;  // Disable counter when wave_out is toggled
    end else if (count == 0) begin
        enable_count <= 1'b1;  // Enable counter when count is reset
    end
end

always @(posedge clk) begin
    if (enable_count) begin
        if (count == (freq - 1)) begin
            count <= 0;  // Reset count
            wave_out <= ~wave_out;  // Toggle wave_out
        end else begin
            count <= count + 1;  // Increment count
        end
    end
end

initial begin
    count = 0;
    wave_out = 0;
    enable_count = 1'b1;
end

endmodule