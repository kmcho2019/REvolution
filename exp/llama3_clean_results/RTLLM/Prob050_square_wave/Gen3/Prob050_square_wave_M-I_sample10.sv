module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;
reg clk_enable = 1'b1; // Clock enable signal for clock gating

always @(posedge clk) begin
    if (clk_enable) begin
        if (count == (freq - 1)) begin
            wave_out <= ~wave_out; // Toggle wave_out using non-blocking assignment
            count <= 8'd0; // Reset count
            clk_enable <= 1'b0; // Disable clock for next cycle
        end else begin
            count <= count + 8'd1; // Increment count using non-blocking assignment
            if (count == (freq - 2)) begin
                clk_enable <= 1'b1; // Enable clock for next cycle
            end
        end
    end
end

initial begin
    wave_out = 1'b0; // Initialize wave_out to a known state
end

endmodule