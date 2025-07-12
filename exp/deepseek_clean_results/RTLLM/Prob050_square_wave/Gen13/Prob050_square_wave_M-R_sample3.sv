module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    wire [7:0] threshold = freq - 1;
    wire counter_max = (count == threshold) && (freq != 0);
    wire counter_enable = (freq == 0) ? 1'b0 : ~freq[7] || (count != 0);
    
    // Next state logic
    wire [7:0] next_count = counter_max ? 8'd0 : (count + 1);
    wire next_wave = (freq == 0) ? 1'b0 : (counter_max ? ~wave_out : wave_out);

    // Sequential update
    always @(posedge clk) begin
        if (counter_enable) begin
            count <= next_count;
            wave_out <= next_wave;
        end
    end

endmodule