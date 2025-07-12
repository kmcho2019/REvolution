module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Counter register

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        count <= 8'd0;  // Reset counter
        wave_out <= ~wave_out;  // Toggle output
    end else begin
        count <= count + 8'd1;  // Increment counter
    end
end

endmodule