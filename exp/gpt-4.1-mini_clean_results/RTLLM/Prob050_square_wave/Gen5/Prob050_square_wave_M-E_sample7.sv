module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            // When freq=0, output held low and count cleared
            wave_out <= 1'b0;
            count <= 8'd0;
        end else if (count == 8'd0) begin
            // Reload counter and toggle output
            count <= freq;
            wave_out <= ~wave_out;
        end else begin
            // Count down
            count <= count - 1'b1;
        end
    end

endmodule