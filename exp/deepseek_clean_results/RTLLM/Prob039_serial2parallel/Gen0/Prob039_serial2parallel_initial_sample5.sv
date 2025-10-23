module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] cnt;          // 3-bit counter (0-7)
    reg [7:0] shift_reg;    // 8-bit shift register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            cnt <= 3'b0;
            shift_reg <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            // Default value for dout_valid
            dout_valid <= 1'b0;

            if (din_valid) begin
                // Shift in new bit (MSB first)
                shift_reg <= {shift_reg[6:0], din_serial};
                
                if (cnt == 3'd7) begin
                    // When 8 bits received
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    cnt <= 3'b0;
                end
                else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule