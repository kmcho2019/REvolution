module square_wave(
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg  [7:0] count;
    reg  [7:0] freq_reg;
    wire [7:0] target;
    wire       reached;
    wire       enable_count;

    // Register freq to avoid glitches and improve timing
    always @(posedge clk) begin
        freq_reg <= freq;
    end

    assign enable_count = (freq_reg != 8'd0);
    assign target = freq_reg - 8'd1;
    assign reached = (count == target);

    always @(posedge clk) begin
        if (!enable_count) begin
            // Reset counter and wave_out when disabled for known state
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (reached) begin
            count    <= 8'd0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 8'd1;
        end
    end

endmodule