module square_wave (
    input  wire        clk,
    input  wire        rst,      // Active-high synchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;

    // Clock enable is high only when freq > 0 to avoid toggling for freq=0
    wire clk_en = (freq != 8'd0);

    always @(posedge clk) begin
        if (rst) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (clk_en) begin
            if (count == freq - 1) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 8'd1;
            end
        end else begin
            // Hold count and output steady when freq is zero
            count    <= count;
            wave_out <= wave_out;
        end
    end

endmodule