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
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
            cnt <= 3'b0;
        end else begin
            if (din_valid) begin
                // Shift in new bit at LSB and shift others left
                dout_parallel <= {dout_parallel[6:0], din_serial};
                
                // Increment counter or reset at 7
                cnt <= (cnt == 3'd7) ? 3'b0 : cnt + 1;
                
                // Set valid when counter is 7
                dout_valid <= (cnt == 3'd7);
            end else begin
                dout_valid <= 1'b0;
            end
        end
    end

endmodule