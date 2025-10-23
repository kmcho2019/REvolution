module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    reg [7:0] freq_thresh = 0;
    wire freq_valid = |freq;  // freq != 0
    wire high_freq = freq[7]; // MSB indicates high frequency
    
    always @(posedge clk) begin
        freq_thresh <= freq - 1;  // Pre-compute threshold
    end

    wire counter_max = freq_valid && (count == freq_thresh);
    wire counter_enable = freq_valid && (!high_freq || (count != 0));
    
    always @(posedge clk) begin
        if (!freq_valid) begin
            wave_out <= 1'b0;  // Handle freq=0 case
            count <= 8'd0;
        end
        else if (counter_enable) begin
            count <= counter_max ? 8'd0 : (count + 1);
            wave_out <= counter_max ? ~wave_out : wave_out;
        end
    end

endmodule