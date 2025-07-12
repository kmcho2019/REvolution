module square_wave (
    input        clk,
    input        rst_n,     // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg  [7:0] count;
    wire [7:0] threshold;
    wire       toggle_condition;
    wire       enabled;

    // Threshold is freq - 1, with saturation at zero for freq=0
    assign threshold = (freq == 8'd0) ? 8'd0 : (freq - 1);
    // Enable counting and toggling only when freq != 0
    assign enabled = (freq != 8'd0);
    // Toggle condition when count equals threshold
    assign toggle_condition = enabled && (count == threshold);

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (enabled) begin
            if (toggle_condition) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            // Hold count and wave_out stable when disabled (freq=0)
            count    <= 8'd0;
            wave_out <= wave_out;
        end
    end

endmodule