module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    wire [7:0] freq_minus_1 = freq - 1'b1;
    wire active = (freq != 8'd0);

    always @(posedge clk) begin
        if (!active) begin
            wave_out <= 1'b0;
            count <= 8'd0;
        end else begin
            if (count == freq_minus_1) begin
                wave_out <= ~wave_out;
                count <= 8'd0;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

endmodule