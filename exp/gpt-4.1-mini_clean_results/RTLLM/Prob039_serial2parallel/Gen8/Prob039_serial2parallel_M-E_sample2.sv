module serial2parallel (
    input            clk,
    input            rst_n,
    input            din_serial,
    input            din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] data_reg;
    reg [3:0] bit_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg      <= 8'b0;
            bit_count     <= 4'd0;
            dout_parallel <= 8'b0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // Default no valid output each cycle

            if (din_valid) begin
                // Shift existing bits left by one, insert new serial bit at LSB
                data_reg <= {data_reg[6:0], din_serial};

                if (bit_count == 4'd7) begin
                    // 8 bits have been received
                    dout_parallel <= {data_reg[6:0], din_serial};
                    dout_valid    <= 1'b1;
                    bit_count     <= 4'd0; // Reset for next byte
                end else begin
                    bit_count <= bit_count + 1;
                end
            end
        end
    end

endmodule