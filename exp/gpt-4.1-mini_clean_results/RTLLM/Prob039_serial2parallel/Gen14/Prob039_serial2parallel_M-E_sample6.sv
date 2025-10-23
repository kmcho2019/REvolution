module serial2parallel (
    input          clk,
    input          rst_n,
    input          din_serial,
    input          din_valid,
    output reg [7:0] dout_parallel,
    output reg     dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] bit_cnt;
    reg [7:0] output_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg     <= 8'b0;
            bit_cnt       <= 4'd0;
            output_reg    <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default to 0 every cycle

            if (din_valid) begin
                // Shift data into shift_reg from MSB side
                // The first bit received is placed into MSB (bit 7)
                shift_reg <= {din_serial, shift_reg[7:1]};
                
                if (bit_cnt == 4'd7) begin
                    // 8 bits received, latch output and assert valid
                    output_reg    <= {din_serial, shift_reg[7:1]};
                    dout_parallel <= {din_serial, shift_reg[7:1]};
                    dout_valid    <= 1'b1;
                    bit_cnt       <= 4'd0;
                end else begin
                    bit_cnt <= bit_cnt + 1'b1;
                end
            end
        end
    end

endmodule