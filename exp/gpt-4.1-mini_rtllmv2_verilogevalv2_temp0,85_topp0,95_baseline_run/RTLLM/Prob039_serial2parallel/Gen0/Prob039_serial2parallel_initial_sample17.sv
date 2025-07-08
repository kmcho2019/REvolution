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
            dout_valid <= 1'b0;  // default deassert

            if (din_valid) begin
                // Shift left by 1 and insert new bit at LSB
                // Since bits are placed MSB to LSB sequentially, 
                // first bit received should go to MSB (bit 7)
                // We'll shift left, so first bit ends up at MSB
                shift_reg <= {shift_reg[6:0], din_serial};
                cnt <= cnt + 1'b1;

                if (cnt == 4'd7) begin
                    // 8 bits received (counting from 0)
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    cnt <= 4'd0;
                    shift_reg <= 8'd0;
                end
            end
        end
    end

endmodule