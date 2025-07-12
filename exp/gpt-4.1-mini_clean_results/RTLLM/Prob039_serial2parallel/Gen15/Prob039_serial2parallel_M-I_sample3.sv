module serial2parallel (
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] bit_count;

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg     <= 8'b0;
            bit_count     <= 4'b0;
            dout_parallel <= 8'b0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default to no valid output every cycle
            if (din_valid) begin
                // Shift left and insert new bit at LSB
                shift_reg <= {shift_reg[6:0], din_serial};
                if (bit_count == 4'd7) begin
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1; // output valid for one cycle
                    bit_count <= 4'b0;   // reset counter after 8 bits collected
                end else begin
                    bit_count <= bit_count + 1'b1;
                end
            end
        end
    end

endmodule