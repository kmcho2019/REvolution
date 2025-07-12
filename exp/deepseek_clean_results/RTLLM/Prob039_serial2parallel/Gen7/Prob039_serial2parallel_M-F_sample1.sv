module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [3:0] cnt;  // 4-bit counter as specified

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
            cnt <= 4'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default to invalid
            
            if (din_valid) begin
                // Shift in new bit (MSB first)
                dout_parallel <= {dout_parallel[6:0], din_serial};
                
                // Increment counter
                cnt <= cnt + 1;
                
                // Check if we've collected 8 bits
                if (cnt == 4'd7) begin
                    dout_valid <= 1'b1;
                    cnt <= 4'b0;  // Reset counter
                end
            end
        end
    end

endmodule