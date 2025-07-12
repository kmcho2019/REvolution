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

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            bit_count     <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // default no valid output each cycle

            if (din_valid) begin
                // Shift left and insert new bit at LSB:
                // This places the first received bit at MSB after 8 shifts
                shift_reg <= {shift_reg[6:0], din_serial};
                bit_count <= bit_count + 1'b1;

                if (bit_count == 4'd7) begin
                    dout_parallel <= {shift_reg[6:0], din_serial}; // full 8 bits collected
                    dout_valid    <= 1'b1;
                    bit_count     <= 4'd0;
                end
            end
        end
    end

endmodule