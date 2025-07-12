module serial2parallel (
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
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
            dout_valid <= 1'b0; // Default: no valid output unless last bit received

            if (din_valid) begin
                // Shift new bit into MSB side, shifting old bits down
                shift_reg <= {din_serial, shift_reg[7:1]};

                if (cnt == 4'd7) begin
                    // 8 bits received: output parallel data and pulse dout_valid
                    dout_parallel <= {din_serial, shift_reg[7:1]}; // or just shift_reg after shift_reg update
                    dout_valid <= 1'b1;
                    cnt <= 4'd0;
                end else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end

endmodule