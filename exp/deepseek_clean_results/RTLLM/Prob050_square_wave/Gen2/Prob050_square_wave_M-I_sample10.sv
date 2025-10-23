module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [6:0] count;  // Reduced to 7 bits
    wire counter_enable = ~freq[7] || (count != 0);  // Clock gating control

    always @(posedge clk) begin
        if (counter_enable) begin
            if (count == 0) begin
                wave_out <= ~wave_out;
                count <= freq[6:0];  // Down-counter initialization
            end else begin
                count <= count - 1;  // Down-counting
            end
        end
    end

endmodule