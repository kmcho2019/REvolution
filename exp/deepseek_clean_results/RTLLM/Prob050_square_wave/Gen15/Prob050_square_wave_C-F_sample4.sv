module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count;
    wire count_enable = (freq != 0);

    always @(posedge clk) begin
        if (count_enable) begin
            if (count == 8'd0) begin
                count <= freq - 1;
                wave_out <= ~wave_out;
            end else begin
                count <= count - 1;
            end
        end else begin
            wave_out <= 1'b0;
            count <= 8'd0;
        end
    end

endmodule