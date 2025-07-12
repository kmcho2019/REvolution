module square_wave (
    input        clk,
    input        rst_n,       // Active low synchronous reset
    input  [7:0] freq,        // Frequency control input
    output reg   wave_out     // Square wave output
);

    reg [7:0] count;
    wire       enable;
    wire       toggle_condition;
    wire [7:0] freq_minus_one;

    // Enable counting and toggling only if freq > 0
    assign enable = (freq != 8'd0);
    assign freq_minus_one = freq - 8'd1;

    // Toggle condition when count reaches freq-1 and enabled
    assign toggle_condition = enable && (count == freq_minus_one);

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (enable) begin
            if (toggle_condition) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            // Hold count and wave_out steady when disabled
            count <= count;
            wave_out <= wave_out;
        end
    end

endmodule