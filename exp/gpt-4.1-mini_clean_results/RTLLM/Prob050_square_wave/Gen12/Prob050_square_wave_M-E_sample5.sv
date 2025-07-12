module square_wave (
    input  wire       clk,
    input  wire [7:0] freq,
    output reg        wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            // Hold count and wave_out steady when freq=0
            count    <= 8'd0;
            wave_out <= wave_out;
        end else begin
            if (count == 8'd0) begin
                count    <= freq;
                wave_out <= ~wave_out;
            end else begin
                count <= count - 8'd1;
            end
        end
    end

    // Initialize wave_out and count to zero at elaboration
    initial begin
        wave_out = 1'b0;
        count    = 8'd0;
    end

endmodule