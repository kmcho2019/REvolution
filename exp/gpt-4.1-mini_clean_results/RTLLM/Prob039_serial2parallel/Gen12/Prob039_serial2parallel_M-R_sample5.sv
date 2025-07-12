module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt;  // 4-bit counter to count from 0 to 8

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // default deassert

            if (din_valid) begin
                // Shift left by 1: MSB to LSB input order (din_serial goes into LSB after shift)
                // But problem wants input placed from MSB to LSB sequentially
                // So insert new bit at MSB and shift right
                shift_reg <= {din_serial, shift_reg[7:1]};

                if (cnt == 4'd7) begin
                    // Received 8 bits
                    dout_parallel <= {din_serial, shift_reg[7:1]};
                    dout_valid    <= 1'b1;
                    cnt           <= 4'd0;  // reset counter to start next byte
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
            // If din_valid is low, hold current registers and counter
        end
    end

endmodule