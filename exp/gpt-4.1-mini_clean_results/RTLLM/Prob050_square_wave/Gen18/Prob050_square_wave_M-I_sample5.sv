module square_wave (
    input  wire       clk,
    input  wire [7:0] freq,
    output reg        wave_out = 1'b0
);

    reg [7:0] count;

    wire enable = (freq != 8'd0);

    always @(posedge clk) begin
        if (enable) begin
            if (count == (freq - 8'd1)) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 8'd1;
            end
        end else begin
            count    <= 8'd0;
            wave_out <= wave_out;  // Hold output steady when freq=0
        end
    end

endmodule