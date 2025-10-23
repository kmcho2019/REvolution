module square_wave (
    input        clk,
    input        rst,       // Active high synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    reg [7:0] freq_minus_one;

    wire enable;
    wire toggle_condition;

    // Enable counting only when freq != 0
    assign enable = (freq != 8'd0);

    // Toggle condition: when count reaches freq_minus_one
    assign toggle_condition = enable && (count == freq_minus_one);

    always @(posedge clk) begin
        if (rst) begin
            count          <= 8'd0;
            freq_minus_one <= 8'd0;
            wave_out       <= 1'b0;
        end else begin
            // Register freq_minus_one to reduce combinational delay
            freq_minus_one <= freq - 1'b1;

            if (toggle_condition) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else if (enable) begin
                count <= count + 1'b1;
            end else begin
                count <= 8'd0;       // Hold count at zero when disabled
                wave_out <= wave_out; // Hold output steady
            end
        end
    end

endmodule