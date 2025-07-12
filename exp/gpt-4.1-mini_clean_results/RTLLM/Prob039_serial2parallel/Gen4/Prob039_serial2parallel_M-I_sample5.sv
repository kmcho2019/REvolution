module serial2parallel (
    input         clk,
    input         rst_n,
    input         din_serial,
    input         din_valid,
    output reg [7:0] dout_parallel,
    output reg      dout_valid
);

    reg [3:0] cnt;            // 4-bit counter (0 to 7)
    reg [7:0] shift_reg;      // shift register for serial data
    reg       full_data;      // flag to indicate full 8 bits received

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt           <= 4'd0;
            shift_reg     <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
            full_data     <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // Default: no valid output

            if (din_valid) begin
                // Shift in new bit at LSB, shifting left to position MSB at first bit received
                shift_reg <= {shift_reg[6:0], din_serial};

                if (cnt == 4'd7) begin
                    // 8 bits received
                    full_data <= 1'b1;
                    cnt <= 4'd0;  // reset counter for next byte
                end else begin
                    cnt <= cnt + 1;
                    full_data <= 1'b0;
                end
            end else begin
                full_data <= 1'b0;
            end

            // Output data and valid pulse when full_data is asserted
            if (full_data) begin
                dout_parallel <= shift_reg;
                dout_valid <= 1'b1;
            end
        end
    end

endmodule