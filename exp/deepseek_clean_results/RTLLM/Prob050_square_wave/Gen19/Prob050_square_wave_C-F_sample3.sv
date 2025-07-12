module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 0) begin
            // Special case: zero frequency means constant low
            wave_out <= 1'b0;
            count <= 8'd0;
        end
        else if (count == 0) begin
            // End of period - toggle output and reload counter
            wave_out <= ~wave_out;
            count <= freq - 1;
        end
        else begin
            // Normal counting
            count <= count - 1;
        end
    end

endmodule