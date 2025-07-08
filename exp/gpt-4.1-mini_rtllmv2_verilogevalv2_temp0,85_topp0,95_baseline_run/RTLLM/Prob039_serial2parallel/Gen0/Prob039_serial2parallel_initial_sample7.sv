module serial2parallel (
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [3:0] cnt;
    reg [7:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 4'd0;
            shift_reg <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else begin
            dout_valid <= 1'b0;
            if (din_valid) begin
                // Shift left and insert din_serial at LSB to build MSB to LSB order
                // Since data should be sequentially placed from MSB to LSB:
                // For first bit, place at bit 7, second bit at bit 6, ..., last bit at bit 0
                // We can do this by shifting left by 1 and inserting din_serial at LSB
                // but this stores MSB first at bit 7.
                shift_reg <= {shift_reg[6:0], din_serial};
                cnt <= cnt + 1'b1;
                if (cnt == 4'd7) begin
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    cnt <= 4'd0;
                end
            end
        end
    end

endmodule