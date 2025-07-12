module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    wire counter_enable = (freq != 0) && (~freq[7] || (count != 0));  // Clock gating for freq=0 and high freq
    wire counter_max = (count == (freq - 1));
    wire next_count = counter_max ? 8'd0 : (count + 1);
    wire next_wave = counter_max ? ~wave_out : wave_out;

    always @(posedge clk) begin
        if (counter_enable) begin
            count <= next_count;
            wave_out <= next_wave;
        end else if (freq == 0) begin
            wave_out <= 1'b0;  // Force output to 0 when freq=0
        end
    end

endmodule