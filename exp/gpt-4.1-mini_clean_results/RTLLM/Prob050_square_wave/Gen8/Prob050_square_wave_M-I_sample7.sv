module square_wave (
    input        clk,
    input        rst_n,        // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    reg [7:0] freq_minus_one;

    // Register freq_minus_one on clk to reduce glitches in combinational subtractor
    always @(posedge clk) begin
        if (!rst_n) begin
            freq_minus_one <= 8'd0;
        end else begin
            freq_minus_one <= freq - 8'd1;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (freq != 8'd0) begin
            if (count == freq_minus_one) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            count <= 8'd0;          // Freeze count when freq is zero
            wave_out <= wave_out;   // Hold wave_out steady
        end
    end

endmodule