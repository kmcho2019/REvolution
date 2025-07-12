module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        wave_out <= ~wave_out; // Toggle the wave_out signal
        count <= 8'd0; // Reset the count to 0
    end else begin
        count <= count + 1; // Increment the count
    end
end

endmodule