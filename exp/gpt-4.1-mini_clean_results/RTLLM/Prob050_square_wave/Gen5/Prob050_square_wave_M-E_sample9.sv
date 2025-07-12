module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            // Hold wave_out low and stop counting if freq is 0 (no toggling)
            wave_out <= 1'b0;
            count <= 8'd0;
        end else begin
            if (count == 8'd0) begin
                // Reload count and toggle output when counter reaches zero
                count <= freq - 1'b1;
                wave_out <= ~wave_out;
            end else begin
                // Decrement counter every clock cycle
                count <= count - 1'b1;
            end
        end
    end

endmodule