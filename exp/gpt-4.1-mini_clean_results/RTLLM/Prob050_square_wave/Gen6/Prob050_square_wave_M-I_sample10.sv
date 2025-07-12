module square_wave (
    input        clk,
    input        rst_n,       // Active-low asynchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;

    // Counting and toggling logic:
    // When freq != 0, count increments each clk cycle.
    // On reaching freq, count resets and wave_out toggles.
    // When freq == 0, hold count and wave_out steady.

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (freq != 8'd0) begin
            if (count == freq) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            count <= count;        // Hold count steady when freq is zero
            wave_out <= wave_out;  // Hold output steady when freq is zero
        end
    end

endmodule