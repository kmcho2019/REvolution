module square_wave (
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            // When freq is zero, hold wave_out and count steady
            wave_out <= wave_out;
            count    <= 8'd0;
        end else begin
            if (count == 8'd0) begin
                count    <= freq;
                wave_out <= ~wave_out;
            end else begin
                count <= count - 1'b1;
            end
        end
    end

    initial begin
        count    = 8'd0;
        wave_out = 1'b0;
    end

endmodule