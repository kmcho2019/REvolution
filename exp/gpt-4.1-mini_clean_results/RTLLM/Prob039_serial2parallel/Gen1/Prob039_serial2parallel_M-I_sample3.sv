module serial2parallel (
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
);

    reg [3:0] cnt;
    reg [7:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 4'd0;
            shift_reg <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // Default low, set high only when data ready

            if (din_valid) begin
                // Shift left and insert new bit at LSB:
                // Since first bit should be MSB, shift left to move old bits toward MSB,
                // placing new bit in LSB.
                shift_reg <= {shift_reg[6:0], din_serial};
                cnt <= cnt + 1;

                if (cnt == 4'd7) begin
                    // On 8th bit, output parallel data and set valid high
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    cnt <= 4'd0;
                end
            end
        end
    end

endmodule