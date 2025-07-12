module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 0) begin
            // Max frequency case - toggle every cycle
            wave_out <= ~wave_out;
            count <= 0;
        end else if (count == 0) begin
            // Normal operation - toggle and reload counter
            wave_out <= ~wave_out;
            count <= freq - 1;
        end else begin
            // Count down
            count <= count - 1;
        end
    end

endmodule