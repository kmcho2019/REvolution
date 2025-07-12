module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;
reg [7:0] target_count = 8'd0;

// Pre-calculate the target count value (freq - 1)
always @(*) begin
    target_count = freq - 1;
end

// Clock gating: Only increment count when it's less than target_count
always @(posedge clk) begin
    if (count < target_count) begin
        count <= count + 8'd1;
    end else begin
        count <= 8'd0;
        wave_out <= ~wave_out; // Toggle wave_out when count reaches target_count
    end
end

endmodule