module square_wave (
    input  wire       clk,
    input  wire       rst,        // Active-high synchronous reset
    input  wire [7:0] freq,
    output reg        wave_out
);

    reg [7:0] count;
    wire count_en = (freq != 8'd0);

    always @(posedge clk) begin
        if (rst) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (count_en) begin
            if (count + 8'd1 == freq) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 8'd1;
            end
        end else begin
            // Hold count and wave_out steady when freq is zero
            count    <= 8'd0;
            wave_out <= wave_out;
        end
    end

endmodule