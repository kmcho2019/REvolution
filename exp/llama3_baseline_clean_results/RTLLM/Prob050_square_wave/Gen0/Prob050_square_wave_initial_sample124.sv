module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count; // Counter register

always @ (posedge clk) begin
    if (count == (freq - 1)) begin
        // Reset count and toggle wave_out when count reaches freq - 1
        count <= 8'd0;
        wave_out <= ~wave_out; // Toggle wave_out
    end else begin
        // Increment count if it has not reached freq - 1
        count <= count + 1;
    end
end

initial begin
    // Initialize count and wave_out
    count <= 8'd0;
    wave_out <= 1'b0;
end

endmodule