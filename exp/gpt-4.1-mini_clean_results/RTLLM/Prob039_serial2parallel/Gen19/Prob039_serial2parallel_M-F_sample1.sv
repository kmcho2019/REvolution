module serial2parallel (
    input          clk,
    input          rst_n,
    input          din_serial,
    input          din_valid,
    output reg [7:0] dout_parallel,
    output reg     dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt;

    // Combinational wire to hold reversed bits of shift_reg
    wire [7:0] reversed_data;

    assign reversed_data = {shift_reg[0], shift_reg[1], shift_reg[2], shift_reg[3],
                            shift_reg[4], shift_reg[5], shift_reg[6], shift_reg[7]};

    // Note: The input bits are shifted in MSB to LSB order (shift_reg[7] is oldest bit)
    // The reversal swaps bit0 with bit7, bit1 with bit6, etc.
    // So we reverse the entire byte by indexing bits in reverse order
    // Correction: reversed_data should be the bit-wise reversal of shift_reg:
    // i.e., reversed_data[7] = shift_reg[0], reversed_data[6] = shift_reg[1], ... reversed_data[0] = shift_reg[7]

    // Let's rewrite reversed_data correctly:

    wire [7:0] reversed_bits;
    assign reversed_bits = {shift_reg[0], shift_reg[1], shift_reg[2], shift_reg[3], 
                            shift_reg[4], shift_reg[5], shift_reg[6], shift_reg[7]};

    // But this is reversed order (LSB to MSB). Since the first received serial bit should be MSB of output,
    // and we shift bits from MSB to LSB, we need reversed_bits as above.

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg     <= 8'b0;
            cnt           <= 4'd0;
            dout_parallel <= 8'b0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default

            if (din_valid) begin
                // Shift left by 1 and insert new bit at LSB
                shift_reg <= {shift_reg[6:0], din_serial};

                if (cnt == 4'd7) begin
                    // 8 bits collected, output reversed bits, set valid
                    dout_parallel <= reversed_bits;
                    dout_valid <= 1'b1;
                    cnt <= 4'd0;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule