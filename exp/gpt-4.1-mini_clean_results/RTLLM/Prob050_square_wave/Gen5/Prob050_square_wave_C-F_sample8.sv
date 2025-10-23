module square_wave (
    input        clk,
    input        rst_n,      // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire       enabled;

    assign enabled = (freq != 8'd0);

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (!enabled) begin
            // Hold count and output steady when freq is zero
            count <= 8'd0;
            wave_out <= wave_out;
        end else if (count == 0) begin
            // Reload counter and toggle output
            count <= freq;
            wave_out <= ~wave_out;
        end else begin
            // Decrement counter
            count <= count - 1'b1;
        end
    end

endmodule