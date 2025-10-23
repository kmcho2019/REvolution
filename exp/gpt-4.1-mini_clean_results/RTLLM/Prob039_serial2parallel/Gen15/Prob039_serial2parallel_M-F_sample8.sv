module serial2parallel (
    input            clk,
    input            rst_n,
    input            din_serial,
    input            din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] bit_count;
    reg       output_flag;

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            bit_count     <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
            output_flag   <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // Default clear dout_valid

            if (din_valid) begin
                // Shift left by 1, insert new bit at LSB:
                // As bits arrive MSB first, we place each bit starting at MSB towards LSB,
                // shifting left ensures the oldest bit is MSB, newest at LSB.
                shift_reg <= {shift_reg[6:0], din_serial};
                
                if (bit_count == 4'd7) begin
                    bit_count   <= 4'd0;
                    output_flag <= 1'b1;  // Signal to output next cycle
                end else begin
                    bit_count   <= bit_count + 1'b1;
                    output_flag <= 1'b0;
                end
            end else begin
                output_flag <= 1'b0;
            end

            if (output_flag) begin
                dout_parallel <= shift_reg;
                dout_valid    <= 1'b1;
            end
        end
    end

endmodule