module serial2parallel (
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
);

    reg [2:0] cnt;           // Counts from 0 to 7 (8 bits)
    reg [7:0] shift_reg;     // Shift register for serial data
    reg       dout_valid_next;
    reg [7:0] dout_parallel_next;

    // Sequential logic: shift in bits and count
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            shift_reg <= 8'd0;
            dout_valid <= 1'b0;
            dout_parallel <= 8'd0;
        end else begin
            dout_valid <= dout_valid_next;
            dout_parallel <= dout_parallel_next;

            dout_valid_next <= 1'b0;  // default no valid output

            if (din_valid) begin
                // Shift new serial bit into MSB side, shifting previous bits right
                shift_reg <= {din_serial, shift_reg[7:1]};

                if (cnt == 3'd7) begin
                    // Received 8 bits: output parallel data and assert valid for one cycle
                    dout_parallel_next <= {din_serial, shift_reg[7:1]};
                    dout_valid_next <= 1'b1;
                    cnt <= 3'd0;
                end else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end

endmodule