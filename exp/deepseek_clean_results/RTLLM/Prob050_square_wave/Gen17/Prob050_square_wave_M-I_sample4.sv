module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    reg [7:0] freq_minus_1 = 0;
    
    // Pre-compute freq-1 to reduce critical path
    always @(posedge clk) begin
        freq_minus_1 <= (freq == 0) ? 8'd0 : (freq - 1);
    end

    // Simplified control logic
    wire counter_max = (count == freq_minus_1);
    wire counter_reset = (freq == 0) || counter_max;
    wire counter_enable = (freq != 0);  // Simple enable for all non-zero frequencies
    
    always @(posedge clk) begin
        if (counter_enable) begin
            count <= counter_reset ? 8'd0 : (count + 1);
            wave_out <= counter_reset ? (freq == 0 ? 1'b0 : ~wave_out) : wave_out;
        end else begin
            wave_out <= 1'b0;  // Handle freq=0 case
        end
    end

endmodule