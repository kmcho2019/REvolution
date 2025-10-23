module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] bit_cnt;  // 3-bit counter (0-7)
    reg [7:0] shift_reg;

    // Combinational output (could be made registered if needed)
    assign dout_parallel = shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 3'b0;
            shift_reg <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default to 0 unless we complete a byte
            
            if (din_valid) begin
                // Shift in new bit
                shift_reg <= {shift_reg[6:0], din_serial};
                
                // Update counter
                if (bit_cnt == 3'd7) begin
                    bit_cnt <= 3'b0;
                    dout_valid <= 1'b1;  // Pulse valid when byte complete
                end
                else begin
                    bit_cnt <= bit_cnt + 1'b1;
                end
            end
        end
    end

endmodule