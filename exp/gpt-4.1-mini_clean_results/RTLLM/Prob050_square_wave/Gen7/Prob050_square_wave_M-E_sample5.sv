module square_wave (
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            // Hold count and output steady when freq is zero
            count    <= 8'd0;
            wave_out <= wave_out;
        end else if (count == freq - 1) begin
            // When counter reaches freq-1, reset and toggle output
            count    <= 8'd0;
            wave_out <= ~wave_out;
        end else begin
            // Increment counter
            count <= count + 1'b1;
            wave_out <= wave_out;
        end
    end

endmodule