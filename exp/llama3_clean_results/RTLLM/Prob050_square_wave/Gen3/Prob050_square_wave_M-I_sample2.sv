module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;
reg enable_clk; // Clock enable signal

always @(posedge clk) begin
    if (enable_clk) begin
        if (count == (freq - 1)) begin
            wave_out <= ~wave_out; // Toggle wave_out using non-blocking assignment
            count <= 8'd0; // Reset count
        end else begin
            count <= count + 8'd1; // Increment count using non-blocking assignment
        end
    end
end

always @(posedge clk) begin
    if (freq == 8'd0) begin
        enable_clk <= 1'b0; // Disable clock when freq is 0
    end else begin
        enable_clk <= 1'b1; // Enable clock when freq is not 0
    end
end

initial begin
    wave_out = 1'b0; // Initialize wave_out to a known state
    enable_clk = 1'b1; // Initialize clock enable to high
end

endmodule