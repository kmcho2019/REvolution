module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;
reg clk_enable = 1'b1; // Default clock enable

always @(posedge clk) begin
    if (clk_enable) begin
        if (count == freq) begin
            count <= 8'd0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 8'd1;
        end
    end
end

// Optional: Clock gating logic based on freq stability
// This part is not directly implemented as it requires additional signals
// to indicate frequency stability, which are not provided in the problem statement.
// However, in a real-world scenario, you would implement logic here to set
// clk_enable based on whether the frequency input has changed.

endmodule