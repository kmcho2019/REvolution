module serial2parallel (
    input            clk,
    input            rst_n,
    input            din_serial,
    input            din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] shift_reg;
    reg [2:0] cnt;  // Counts from 0 to 7

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            cnt           <= 3'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // Default de-assert

            if (din_valid) begin
                // Shift right by 1, insert new bit at MSB
                shift_reg <= {din_serial, shift_reg[7:1]};
                if (cnt == 3'd7) begin
                    // 8 bits collected
                    dout_parallel <= {din_serial, shift_reg[7:1]};
                    dout_valid    <= 1'b1;
                    cnt           <= 3'd0;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule