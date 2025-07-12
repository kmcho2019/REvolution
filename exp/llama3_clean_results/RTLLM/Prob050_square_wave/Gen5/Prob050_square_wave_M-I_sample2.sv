module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;
reg enable_count = 1'b1;

always @(posedge clk) begin
    if (enable_count) begin
        if (count == (freq - 1)) begin
            wave_out <= ~wave_out; // Toggle wave_out
            count <= 8'd0; // Reset count
        end else begin
            count <= count + 8'd1; // Increment count
        end
    end
end

always @(*) begin
    if (freq == 8'd0) begin
        enable_count = 1'b0; // Disable counting if freq is 0
    end else begin
        enable_count = 1'b1; // Enable counting otherwise
    end
end

initial begin
    wave_out = 1'b0; // Initialize wave_out to a known state
end

endmodule