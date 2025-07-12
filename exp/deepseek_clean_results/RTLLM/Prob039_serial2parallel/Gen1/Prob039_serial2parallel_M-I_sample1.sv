module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] cnt;          // 3-bit counter (0-7)
    wire cnt_terminal = (cnt == 3'd7);  // Terminal count signal
    reg din_valid_reg;      // Registered version of din_valid

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            cnt <= 3'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
            din_valid_reg <= 1'b0;
        end
        else begin
            // Register input valid signal
            din_valid_reg <= din_valid;
            
            // Default assignments
            dout_valid <= 1'b0;

            if (din_valid_reg) begin
                // Shift new bit into LSB (MSB first ordering)
                dout_parallel <= {dout_parallel[6:0], din_serial};
                
                if (cnt_terminal) begin
                    // When 8 bits received
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