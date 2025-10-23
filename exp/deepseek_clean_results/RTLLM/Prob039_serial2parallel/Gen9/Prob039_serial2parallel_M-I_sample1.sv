module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] cnt;  // 3-bit counter (0-7)
    wire cnt_full = (cnt == 3'd7);  // Counter full indicator

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            // Default assignments
            dout_valid <= 1'b0;

            if (din_valid) begin
                // Shift register update
                dout_parallel <= {dout_parallel[6:0], din_serial};
                
                // Counter update
                if (cnt_full) begin
                    cnt <= 3'b0;
                    dout_valid <= 1'b1;  // Valid for one cycle
                end
                else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end

endmodule