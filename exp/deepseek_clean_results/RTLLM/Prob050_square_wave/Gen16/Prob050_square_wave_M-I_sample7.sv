module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    parameter COUNTER_WIDTH = 8;
    reg [COUNTER_WIDTH-1:0] count = 0;
    reg [COUNTER_WIDTH-1:0] freq_minus_1 = 0;
    
    // Pre-compute comparison value
    always @(posedge clk) begin
        freq_minus_1 <= (freq == 0) ? 8'd0 : (freq - 1);
    end

    // Simplified control logic
    wire counter_max = (count == freq_minus_1);
    wire counter_enable = (freq != 0);  // Simple enable when not zero
    
    // Next state logic
    wire [COUNTER_WIDTH-1:0] next_count = counter_max ? 8'd0 : (count + 1);
    wire next_wave = (freq == 0) ? 1'b0 : (counter_max ? ~wave_out : wave_out);

    always @(posedge clk) begin
        if (counter_enable) begin
            count <= next_count;
            wave_out <= next_wave;
        end
    end

endmodule