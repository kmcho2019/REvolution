module serial2parallel (
    input            clk,
    input            rst_n,
    input            din_serial,
    input            din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] bit_cnt;

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            bit_cnt       <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // Default no output valid each cycle

            if (din_valid) begin
                // Shift left by 1, insert din_serial at LSB
                // Since first bit goes to MSB, and next bits fill down to LSB,
                // we shift left to move old bits towards MSB and insert new bit at LSB.
                shift_reg <= {shift_reg[6:0], din_serial};
                bit_cnt <= bit_cnt + 1'b1;

                if (bit_cnt == 4'd7) begin
                    // 8 bits received; output data is ready this cycle
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid    <= 1'b1;
                    bit_cnt       <= 4'd0;
                end
            end
        end
    end

endmodule