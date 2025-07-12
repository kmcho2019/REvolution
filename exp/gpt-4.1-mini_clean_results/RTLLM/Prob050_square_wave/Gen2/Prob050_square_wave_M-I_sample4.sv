module square_wave(
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg  [7:0] count;
    reg  [7:0] freq_reg;
    wire [7:0] target = freq_reg - 8'd1;
    wire       enabled = (freq_reg != 8'd0);
    wire       reached = enabled && (count == target);

    // Register freq to avoid glitches
    always @(posedge clk) begin
        freq_reg <= freq;
    end

    always @(posedge clk) begin
        if (enabled) begin
            if (reached) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 8'd1;
            end
        end else begin
            count    <= 8'd0;       // reset count when disabled
            wave_out <= 1'b0;       // optional: reset output when freq=0
        end
    end

endmodule