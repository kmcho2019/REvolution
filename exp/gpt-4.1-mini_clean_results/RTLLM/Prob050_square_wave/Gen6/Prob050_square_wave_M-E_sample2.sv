module square_wave (
    input        clk,
    input        rst_n,      // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    reg [7:0] half_period;

    wire freq_nonzero = (freq != 8'd0);

    always @(posedge clk) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
            half_period <= 8'd0;
        end else begin
            if (freq_nonzero) begin
                half_period <= freq >> 1; // calculate half period dynamically
                if (count == half_period) begin
                    count <= 8'd0;
                    wave_out <= ~wave_out;
                end else begin
                    count <= count + 1'b1;
                end
            end else begin
                // freq == 0, hold count and wave_out steady
                count <= 8'd0;
                wave_out <= wave_out;
                half_period <= 8'd0;
            end
        end
    end

endmodule