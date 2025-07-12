module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [5:0] count;
    wire count_enable = |freq;  // Clock gating control
    
    always @(posedge clk) begin
        if (count_enable) begin
            if (count == 0) begin
                count <= freq[5:0];  // Reload counter
                wave_out <= ~wave_out;  // Toggle output
            end else begin
                count <= count - 1;  // Decrement counter
            end
        end
    end

endmodule