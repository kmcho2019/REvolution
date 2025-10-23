module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg      dout_valid
);

    reg [2:0] cnt;          // 3-bit counter (0 to 7)
    reg [7:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt           <= 3'd0;
            shift_reg     <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default to 0 every cycle

            if (din_valid) begin
                // Shift left by 1 and insert new bit at LSB
                shift_reg <= {shift_reg[6:0], din_serial};

                if (cnt == 3'd7) begin
                    // After receiving 8 bits
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    cnt <= 3'd0;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule