module serial2parallel (
    input            clk,
    input            rst_n,
    input            din_serial,
    input            din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [2:0] bit_cnt;        // 3-bit counter: counts 0 to 7
    reg [7:0] shift_reg;      // Shift register for assembling parallel data

    always @(posedge clk) begin
        if (!rst_n) begin
            bit_cnt      <= 3'd0;
            shift_reg    <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid   <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // default deassert

            if (din_valid) begin
                shift_reg <= {shift_reg[6:0], din_serial}; // Shift left, insert new bit at LSB

                if (bit_cnt == 3'd7) begin
                    dout_parallel <= {shift_reg[6:0], din_serial}; // output full 8 bits
                    dout_valid <= 1'b1;
                    bit_cnt <= 3'd0;  // reset counter
                end else begin
                    bit_cnt <= bit_cnt + 3'd1;
                end
            end
        end
    end

endmodule