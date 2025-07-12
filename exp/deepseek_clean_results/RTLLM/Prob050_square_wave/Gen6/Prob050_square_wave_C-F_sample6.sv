module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [6:0] count;
    wire counter_enable = (freq != 0);  // Simple clock gating for freq=0 case

    always @(posedge clk) begin
        if (counter_enable) begin
            if (count == 0) begin
                wave_out <= ~wave_out;
                count <= freq[6:0];  // Down-counter reload
            end else begin
                count <= count - 1;  // Decrement counter
            end
        end
    end

endmodule