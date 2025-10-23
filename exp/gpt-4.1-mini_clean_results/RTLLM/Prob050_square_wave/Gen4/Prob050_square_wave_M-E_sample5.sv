module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 0) begin
            // Hold steady output and counter at zero when freq is zero
            wave_out <= wave_out;
            count <= 8'b0;
        end else if (count == 0) begin
            // Toggle output and reload counter
            wave_out <= ~wave_out;
            count <= freq;
        end else begin
            // Decrement counter
            count <= count - 1;
        end
    end

endmodule