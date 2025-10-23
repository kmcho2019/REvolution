module serial2parallel (
    input            clk,
    input            rst_n,
    input            din_serial,
    input            din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // Default: no valid output unless full byte collected
            if (din_valid) begin
                // Shift left by 1, insert new bit at LSB; MSB is oldest bit, LSB is newest
                shift_reg <= {shift_reg[6:0], din_serial};
                cnt <= cnt + 1;

                if (cnt == 4'd7) begin
                    // After receiving 8 bits, output the full register and assert valid
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    cnt <= 4'd0; // Reset counter for next byte
                end
            end
        end
    end

endmodule