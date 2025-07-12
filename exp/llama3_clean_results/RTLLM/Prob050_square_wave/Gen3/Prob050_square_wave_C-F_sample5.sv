module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        wave_out <= ~wave_out; // Toggle wave_out
        count <= 8'd0; // Reset count
    end else begin
        count <= count + 8'd1; // Increment count
    end
end

endmodule