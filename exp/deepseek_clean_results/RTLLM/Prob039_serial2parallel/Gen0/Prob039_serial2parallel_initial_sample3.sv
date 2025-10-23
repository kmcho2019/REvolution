module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [3:0] cnt;          // 4-bit counter (needs to count to 8)
    reg [7:0] shift_reg;    // 8-bit shift register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            cnt <= 4'b0;
            shift_reg <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            // Default value for dout_valid (only pulses for one cycle)
            dout_valid <= 1'b0;

            if (din_valid) begin
                // Shift in new bit (MSB first)
                shift_reg <= {shift_reg[6:0], din_serial};
                cnt <= cnt + 1;

                // When we've collected 8 bits
                if (cnt == 4'd7) begin
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    cnt <= 4'b0;
                end
            end
        end
    end

endmodule