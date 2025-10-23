module square_wave (
    input  wire        clk,
    input  wire        rst,       // Active-high synchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;
    wire       count_enable = (freq != 8'd0);
    wire [7:0] freq_minus_1 = freq - 8'd1;

    always @(posedge clk) begin
        if (rst) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (!count_enable) begin
            // Hold count and output steady when freq is zero
            count    <= 8'd0;
            wave_out <= wave_out;
        end else begin
            if (count == freq_minus_1) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 8'd1;
            end
        end
    end

endmodule