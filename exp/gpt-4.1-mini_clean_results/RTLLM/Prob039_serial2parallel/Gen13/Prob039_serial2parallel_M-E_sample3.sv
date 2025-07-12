module serial2parallel (
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] bit_count;

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg    <= 8'b0;
            bit_count    <= 4'b0;
            dout_parallel <= 8'b0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // default no valid output

            if (din_valid) begin
                // Shift left by 1, insert din_serial at MSB
                shift_reg <= {shift_reg[6:0], din_serial};
                bit_count <= bit_count + 1'b1;

                if (bit_count == 4'd7) begin
                    // After receiving 8 bits, output parallel data
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    bit_count <= 4'b0;  // reset counter
                end
            end
        end
    end

endmodule