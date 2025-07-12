module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 0) begin
            // Hold output steady and reset counter when freq = 0
            wave_out <= wave_out;
            count <= 0;
        end else if (count == 0) begin
            // Reload counter and toggle wave_out when counter expires
            count <= freq - 1;
            wave_out <= ~wave_out;
        end else begin
            // Decrement counter every clock cycle
            count <= count - 1;
        end
    end

endmodule