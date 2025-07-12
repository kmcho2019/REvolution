module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] phase_error;
reg [7:0] loop_filter_output;
reg pll_clk;

always @(posedge clk) begin
    // Phase detector
    if (clk == pll_clk) begin
        phase_error <= 8'd0;
    end else if (clk == 1'b1 && pll_clk == 1'b0) begin
        phase_error <= phase_error + 8'd1;
    end else if (clk == 1'b0 && pll_clk == 1'b1) begin
        phase_error <= phase_error - 8'd1;
    end

    // Loop filter
    loop_filter_output <= (loop_filter_output + phase_error) / 2;

    // VCO
    if (loop_filter_output < freq) begin
        pll_clk <= 1'b1;
    end else begin
        pll_clk <= 1'b0;
    end
end

always @(posedge pll_clk) begin
    // Flip-flop to generate square wave
    wave_out <= ~wave_out;
end

endmodule