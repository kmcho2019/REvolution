module square_wave (
    input        clk,
    input        rst,      // Active high synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (rst) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (freq == 8'd0) begin
            // Hold output and counter steady when freq is zero
            count <= 8'd0;
            wave_out <= wave_out;
        end else begin
            if (count == 8'd0) begin
                // Reload count and toggle output
                count    <= freq;
                wave_out <= ~wave_out;
            end else begin
                count <= count - 1'b1;
            end
        end
    end

endmodule