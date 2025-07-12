module square_wave (
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire [7:0] freq_minus_one;
    wire       enable_count;
    wire       toggle_condition;

    assign freq_minus_one = freq - 8'd1;
    assign enable_count = (freq != 8'd0);
    assign toggle_condition = enable_count && (count == freq_minus_one);

    always @(posedge clk) begin
        if (enable_count) begin
            if (toggle_condition) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 8'd1;
            end
        end else begin
            // Hold outputs steady when disabled
            count    <= 8'd0;
            wave_out <= wave_out;
        end
    end

endmodule