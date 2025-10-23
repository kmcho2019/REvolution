module square_wave (
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            // Hold wave_out and count steady if freq is zero (no toggling)
            count <= count;
            wave_out <= wave_out;
        end else begin
            if (count == 8'd0) begin
                count <= freq;        // Reload count
                wave_out <= ~wave_out; // Toggle wave_out
            end else begin
                count <= count - 1'b1; // Decrement count
                wave_out <= wave_out;
            end
        end
    end

    // Initialize count and wave_out at elaboration time to avoid unknowns
    initial begin
        count = 8'd0;
        wave_out = 1'b0;
    end

endmodule