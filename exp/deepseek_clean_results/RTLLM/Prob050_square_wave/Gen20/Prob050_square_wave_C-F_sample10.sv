module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    reg [7:0] freq_minus_1;
    wire counter_enable = (freq != 0);
    wire counter_max = (count == freq_minus_1);

    always @(posedge clk) begin
        freq_minus_1 <= freq - 1;  // Pre-compute for better timing
        
        if (!counter_enable) begin
            wave_out <= 1'b0;      // Handle freq=0 case
            count <= 8'd0;
        end
        else if (counter_max) begin
            count <= 8'd0;
            wave_out <= ~wave_out; // Toggle output
        end
        else begin
            count <= count + 1;    // Increment counter
        end
    end

endmodule