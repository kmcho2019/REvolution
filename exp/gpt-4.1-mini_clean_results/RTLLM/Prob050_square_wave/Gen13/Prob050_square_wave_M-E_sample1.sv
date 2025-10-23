module square_wave (
    input wire clk,
    input wire [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            // When freq is zero, hold output steady and counter zero
            count <= 8'd0;
            wave_out <= wave_out;
        end else begin
            if (count == 8'd0) begin
                // Reload counter and toggle output
                count <= freq;
                wave_out <= ~wave_out;
            end else begin
                // Decrement counter
                count <= count - 1'b1;
            end
        end
    end

endmodule