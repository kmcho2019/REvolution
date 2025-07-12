module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    reg [7:0] freq_minus_1 = 0;
    
    // Pre-compute comparison value
    always @(posedge clk) begin
        freq_minus_1 <= (freq == 0) ? 8'd0 : (freq - 1);
    end

    always @(posedge clk) begin
        if (freq == 0) begin
            // Special case: freq=0 forces output low
            wave_out <= 1'b0;
            count <= 8'd0;
        end else if (freq == 1) begin
            // Minimum frequency case (max toggle rate)
            wave_out <= ~wave_out;
            count <= 8'd0;
        end else begin
            // Normal operation
            if (count == freq_minus_1) begin
                wave_out <= ~wave_out;
                count <= 8'd0;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule