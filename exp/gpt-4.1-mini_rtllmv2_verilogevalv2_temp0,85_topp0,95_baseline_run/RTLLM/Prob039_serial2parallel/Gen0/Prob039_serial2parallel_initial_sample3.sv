module serial2parallel (
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [3:0] cnt;  // 4-bit counter to count up to 8 bits
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt          <= 4'd0;
            shift_reg    <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid   <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // default to 0, set to 1 only when 8 bits received
            if (din_valid) begin
                // Shift serial data into register from MSB to LSB
                shift_reg <= {shift_reg[6:0], din_serial};
                cnt <= cnt + 1'b1;
                if (cnt == 4'd7) begin
                    // After receiving 8 bits (count from 0 to 7)
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    cnt <= 4'd0;  // reset counter for next 8 bits
                end
            end
        end
    end

endmodule