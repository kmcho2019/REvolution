module serial2parallel (
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
);

    reg [3:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count     <= 4'd0;
            shift_reg     <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // default no valid output

            if (din_valid) begin
                // Shift right, insert new bit at MSB
                shift_reg <= {din_serial, shift_reg[7:1]};
                bit_count <= bit_count + 4'd1;

                if (bit_count == 4'd7) begin
                    // After 8 bits received, output data and valid pulse
                    dout_parallel <= {din_serial, shift_reg[7:1]};
                    dout_valid    <= 1'b1;
                    bit_count     <= 4'd0;
                    // shift_reg will be overwritten next valid inputs, no explicit reset needed here
                end
            end
        end
    end

endmodule