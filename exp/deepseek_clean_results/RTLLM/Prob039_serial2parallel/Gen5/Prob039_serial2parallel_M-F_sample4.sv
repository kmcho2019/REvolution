module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] cnt;        // 3-bit counter (0-7)
    reg [7:0] buffer;     // Shift register for serial input

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0;
            buffer <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            // Default assignments
            dout_valid <= 1'b0;

            if (din_valid) begin
                // Shift new bit into buffer (MSB first)
                buffer <= {buffer[6:0], din_serial};
                
                // Increment counter
                if (cnt == 3'd7) begin
                    cnt <= 3'b0;
                    // Output the complete buffer on next cycle
                    dout_parallel <= {buffer[6:0], din_serial};
                    dout_valid <= 1'b1;
                end
                else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule