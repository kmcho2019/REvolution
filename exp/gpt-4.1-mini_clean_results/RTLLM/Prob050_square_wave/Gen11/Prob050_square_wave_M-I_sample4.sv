module square_wave (
    input        clk,
    input        rst_n,       // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    reg [7:0] freq_minus_one;
    wire      enabled;
    wire      toggle_condition;

    // Enable counting only when freq is non-zero
    assign enabled = (freq != 8'd0);

    // toggle_condition: count reached freq-1 (max count)
    assign toggle_condition = enabled && (count == freq_minus_one);

    always @(posedge clk) begin
        if (!rst_n) begin
            count         <= 8'd0;
            freq_minus_one<= 8'd0;
            wave_out      <= 1'b0;
        end else begin
            freq_minus_one <= (freq == 8'd0) ? 8'd0 : freq - 8'd1;
            if (enabled) begin
                if (toggle_condition) begin
                    count    <= 8'd0;
                    wave_out <= ~wave_out;
                end else begin
                    count <= count + 8'd1;
                end
            end else begin
                count    <= 8'd0;
                wave_out <= wave_out; // Hold steady when disabled
            end
        end
    end

endmodule