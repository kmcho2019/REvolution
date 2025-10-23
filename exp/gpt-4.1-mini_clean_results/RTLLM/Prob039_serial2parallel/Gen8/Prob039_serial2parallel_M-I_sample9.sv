module serial2parallel (
    input         clk,
    input         rst_n,
    input         din_serial,
    input         din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt;  // Counts received bits: 0 to 7

    // Clock enable: only shift and count when input is valid
    wire ce = din_valid;

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg    <= 8'd0;
            cnt          <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid   <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // Default output valid low

            if (ce) begin
                // Shift left by 1, new serial bit at LSB
                shift_reg <= {shift_reg[6:0], din_serial};

                if (cnt == 4'd7) begin
                    // 8 bits accumulated, output parallel data
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid    <= 1'b1;
                    cnt           <= 4'd0;  // Reset counter for next byte
                end else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end

endmodule