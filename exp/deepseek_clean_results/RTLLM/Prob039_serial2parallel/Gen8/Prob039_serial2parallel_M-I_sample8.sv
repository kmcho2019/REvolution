module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] cnt;  // 3-bit counter (0-7)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            {dout_parallel, dout_valid, cnt} <= {8'b0, 1'b0, 3'b0};
        end
        else begin
            // Default assignments
            dout_valid <= 1'b0;
            
            if (din_valid) begin
                // Shift in new bit (MSB first)
                dout_parallel <= {dout_parallel[6:0], din_serial};
                
                // Increment counter only when enabled
                cnt <= cnt + 1;
                
                // Check if we've collected 8 bits (cnt will be 7 at this point)
                if (cnt == 3'd7) begin
                    dout_valid <= 1'b1;
                    cnt <= 3'b0;  // Reset counter
                end
            end
        end
    end

endmodule