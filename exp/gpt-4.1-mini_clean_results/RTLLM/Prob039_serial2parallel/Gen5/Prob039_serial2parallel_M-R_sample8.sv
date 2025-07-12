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

    // Internal signal to detect when 8 bits collected
    wire last_bit_received = (cnt == 4'd7) && din_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 4'd0;
            shift_reg <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default no valid output

            if (din_valid) begin
                // Shift left: earliest bit at MSB, newest at LSB
                shift_reg <= {shift_reg[6:0], din_serial};

                if (cnt == 4'd7) begin
                    cnt <= 4'd0;
                    dout_parallel <= {shift_reg[6:0], din_serial}; // complete 8 bits
                    dout_valid <= 1'b1;
                end else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end

endmodule