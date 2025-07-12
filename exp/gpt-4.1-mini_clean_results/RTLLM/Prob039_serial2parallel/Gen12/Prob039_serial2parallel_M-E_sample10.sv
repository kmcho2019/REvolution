module serial2parallel (
    input          clk,
    input          rst_n,
    input          din_serial,
    input          din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt;  // 4-bit counter to count up to 8

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // Default, only pulse high on 8th bit
            
            if (din_valid) begin
                // Shift left by 1, input bit inserted at LSB
                shift_reg <= {shift_reg[6:0], din_serial};
                cnt <= cnt + 1'b1;
                
                if (cnt == 4'd7) begin
                    // On receiving the 8th bit (cnt from 0..7)
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    cnt <= 4'd0;  // Reset counter after output valid
                end
            end
        end
    end

endmodule