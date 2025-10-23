module serial2parallel (
    input            clk,
    input            rst_n,
    input            din_serial,
    input            din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt;  // 4-bit counter counting 0 to 7

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default clear dout_valid

            if (din_valid) begin
                // Shift left by 1: MSB is oldest bit, LSB is newest
                shift_reg <= {shift_reg[6:0], din_serial};

                if (cnt == 4'd7) begin
                    // 8 bits collected
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    cnt <= 4'd0;
                end else begin
                    cnt <= cnt + 4'd1;
                end
            end
        end
    end

endmodule