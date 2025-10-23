module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg      dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt;

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // Default to 0 every cycle

            if (din_valid) begin
                // Shift left by one, insert new bit at LSB,
                // so first bit received eventually ends up at MSB.
                shift_reg <= {shift_reg[6:0], din_serial};

                if (cnt == 4'd7) begin
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid    <= 1'b1;  // Output valid for one cycle
                    cnt           <= 4'd0;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule