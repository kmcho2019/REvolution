module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [3:0] cnt;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 4'd0;
            shift_reg <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // Default deassert

            if (din_valid) begin
                // Shift in din_serial MSB-first:
                // shift_reg[7] is oldest, shift_reg[0] is newest bit
                shift_reg <= {shift_reg[6:0], din_serial};

                if (cnt == 4'd7) begin
                    // 8 bits received, output data and assert valid for one cycle
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    cnt <= 4'd0; // reset counter for next byte
                    // Keep shift_reg intact so output stays stable next cycle
                end else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end

endmodule