module square_wave (
    input        clk,
    input        rst_n,     // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire [7:0] freq_minus_one;
    wire       enable;
    wire       toggle_condition;

    // Compute freq_minus_one safely; if freq=0, freq_minus_one wraps to 255 but enable disables counting
    assign freq_minus_one = freq - 8'd1;
    assign enable = (freq != 8'd0);
    assign toggle_condition = enable && (count == freq_minus_one);

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (toggle_condition) begin
            count    <= 8'd0;
            wave_out <= ~wave_out;
        end else if (enable) begin
            count <= count + 1'b1;
        end else begin
            count <= 8'd0;   // Hold count at zero when disabled
            wave_out <= wave_out; // Hold output steady
        end
    end

endmodule