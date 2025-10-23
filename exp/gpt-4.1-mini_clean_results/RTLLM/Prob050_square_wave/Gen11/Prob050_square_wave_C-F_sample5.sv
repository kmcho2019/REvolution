module square_wave (
    input        clk,
    input        rst_n,         // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire [7:0] freq_minus_one = freq - 8'd1;
    wire       clk_en = (freq != 8'd0);

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (clk_en) begin
            if (count == freq_minus_one) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            // Hold count and wave_out steady when freq=0 to save power
            count <= count;
            wave_out <= wave_out;
        end
    end

endmodule