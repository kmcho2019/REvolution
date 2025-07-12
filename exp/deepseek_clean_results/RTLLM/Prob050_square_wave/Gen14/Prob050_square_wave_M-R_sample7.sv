module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;

    always @(posedge clk) begin
        if (freq == 0) begin
            // Reset case - output stays low
            count <= 0;
            wave_out <= 0;
        end
        else if (count >= freq - 1) begin
            // Toggle output and reset counter
            count <= 0;
            wave_out <= ~wave_out;
        end
        else begin
            // Normal counting
            count <= count + 1;
        end
    end

endmodule