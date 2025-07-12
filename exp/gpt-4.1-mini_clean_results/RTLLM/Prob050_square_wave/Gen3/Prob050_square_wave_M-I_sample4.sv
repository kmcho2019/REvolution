module square_wave(
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg  [7:0] count;
    reg  [7:0] freq_reg;

    // Register freq to improve timing and reduce glitches
    always @(posedge clk) begin
        freq_reg <= freq;
    end

    wire [7:0] target = freq_reg - 8'd1;
    wire       enable = (freq_reg != 8'd0);
    wire       reached = (count == target);

    always @(posedge clk) begin
        if (enable) begin
            if (reached) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 8'd1;
            end
        end else begin
            count    <= 8'd0;
            wave_out <= 1'b0; // output low when freq is zero (no toggling)
        end
    end

endmodule