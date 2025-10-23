module serial2parallel (
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt; // 4-bit counter for counting up to 8 bits

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'd0;
            cnt <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default no valid output

            if (din_valid) begin
                shift_reg <= {shift_reg[6:0], din_serial}; // Shift left, input bit at LSB
                if (cnt == 4'd7) begin
                    dout_parallel <= {shift_reg[6:0], din_serial}; // Output the 8-bit data
                    dout_valid <= 1'b1; // signal data valid for one cycle
                    cnt <= 4'd0; // reset counter after 8 bits
                end else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end

endmodule