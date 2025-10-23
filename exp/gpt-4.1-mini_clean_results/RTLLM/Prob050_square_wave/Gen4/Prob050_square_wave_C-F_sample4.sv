module square_wave (
    input        clk,
    input        rst_n,     // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire      enabled;
    wire      toggle_condition;

    // Enable counting and toggling only when freq is non-zero
    assign enabled = (freq != 8'd0);
    // Toggle when count reaches zero (countdown approach)
    assign toggle_condition = enabled && (count == 8'd0);

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (enabled) begin
            if (toggle_condition) begin
                count    <= freq;
                wave_out <= ~wave_out;
            end else begin
                count <= count - 1'b1;
            end
        end else begin
            // Hold count and wave_out steady when disabled
            count    <= 8'd0;
            wave_out <= wave_out;
        end
    end

endmodule