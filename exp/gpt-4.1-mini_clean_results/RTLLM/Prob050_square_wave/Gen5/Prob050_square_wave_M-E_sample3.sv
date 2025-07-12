module square_wave (
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    reg [7:0] half_period;

    wire counting_enabled;
    wire toggle_condition;

    // Counting enabled only if freq >= 2, since half_period = freq/2 must be > 0
    assign counting_enabled = (freq >= 8'd2);

    // Compute half_period as freq divided by 2 (floor)
    // Use shift right by 1 for division by 2
    always @(*) begin
        half_period = freq >> 1;
    end

    // Toggle condition when count reaches half_period - 1
    assign toggle_condition = counting_enabled && (count == (half_period - 1));

    always @(posedge clk) begin
        if (!counting_enabled) begin
            // Hold wave_out steady and reset count when freq < 2
            wave_out <= wave_out;
            count    <= 8'd0;
        end else begin
            if (toggle_condition) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

endmodule