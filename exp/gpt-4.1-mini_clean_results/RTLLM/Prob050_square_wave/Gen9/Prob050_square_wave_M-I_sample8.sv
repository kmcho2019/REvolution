module square_wave (
    input        clk,
    input        rst_n,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    reg [7:0] freq_threshold;

    // Precompute freq_threshold as freq - 1 when freq != 0
    always @(*) begin
        if (freq != 8'd0)
            freq_threshold = freq - 8'd1;
        else
            freq_threshold = 8'd0;
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (freq != 8'd0) begin
            if (count == freq_threshold) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            // Hold count and wave_out steady when freq is zero
            count <= count;
            wave_out <= wave_out;
        end
    end

endmodule