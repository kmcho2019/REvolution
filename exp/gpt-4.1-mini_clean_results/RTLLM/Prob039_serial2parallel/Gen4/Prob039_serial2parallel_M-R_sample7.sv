module serial2parallel (
    input            clk,
    input            rst_n,
    input            din_serial,
    input            din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [2:0] cnt;       // 3-bit counter counts from 0 to 7
    reg [7:0] shift_reg; // shift register to accumulate bits

    // Shift register: shifts left, new bit into LSB
    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg <= 8'd0;
        end else if (din_valid) begin
            // Shift left: MSB oldest bit, LSB newest bit
            shift_reg <= {shift_reg[6:0], din_serial};
        end
    end

    // Counter: increments on valid data
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // Default deassert

            if (din_valid) begin
                if (cnt == 3'd7) begin
                    // 8 bits received, output parallel data
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    cnt <= 3'd0;
                end else begin
                    cnt <= cnt + 3'd1;
                end
            end
        end
    end

endmodule