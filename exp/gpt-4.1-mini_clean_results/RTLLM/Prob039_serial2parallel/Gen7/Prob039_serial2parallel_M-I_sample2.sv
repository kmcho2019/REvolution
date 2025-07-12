module serial2parallel (
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt; // counts from 0 to 7

    wire ce = din_valid; // clock enable derived from input valid

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg    <= 8'd0;
            cnt          <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid   <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default no valid output each cycle

            if (ce) begin
                // Shift left and insert din_serial at LSB for MSB-first input order
                shift_reg <= {shift_reg[6:0], din_serial};

                if (cnt == 4'd7) begin
                    // 8 bits received: output parallel data and valid signal
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid   <= 1'b1;
                    cnt          <= 4'd0; // reset counter for next byte
                end else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end

endmodule