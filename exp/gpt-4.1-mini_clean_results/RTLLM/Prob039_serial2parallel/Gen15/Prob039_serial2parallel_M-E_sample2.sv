module serial2parallel (
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] bit_count;  // can count from 0 to 8

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg    <= 8'b0;
            bit_count    <= 4'd0;
            dout_parallel <= 8'b0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default no valid output

            if (din_valid) begin
                // Assign current bit to position (7 - bit_count)
                shift_reg[7 - bit_count] <= din_serial;

                if (bit_count == 4'd7) begin
                    // Received 8 bits, output parallel data
                    dout_parallel <= {shift_reg[7:1], din_serial};
                    dout_valid <= 1'b1;
                    bit_count <= 4'd0; // reset for next word
                end else begin
                    bit_count <= bit_count + 1'b1;
                end
            end
        end
    end

endmodule