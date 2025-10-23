module square_wave (
    input        clk,
    input        rst_n,     // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire      enable;
    wire [7:0] freq_minus_one;
    wire      toggle_pulse;

    assign enable = (freq != 8'd0);
    assign freq_minus_one = freq - 8'd1;
    assign toggle_pulse = enable && (count == freq_minus_one);

    // Counter increments while enable is high, resets to zero on toggle_pulse or reset
    always @(posedge clk) begin
        if (!rst_n)
            count <= 8'd0;
        else if (enable) begin
            if (toggle_pulse)
                count <= 8'd0;
            else
                count <= count + 1'b1;
        end else begin
            count <= 8'd0;
        end
    end

    // Toggle wave_out only on toggle_pulse
    always @(posedge clk) begin
        if (!rst_n)
            wave_out <= 1'b0;
        else if (toggle_pulse)
            wave_out <= ~wave_out;
        else
            wave_out <= wave_out;
    end

endmodule