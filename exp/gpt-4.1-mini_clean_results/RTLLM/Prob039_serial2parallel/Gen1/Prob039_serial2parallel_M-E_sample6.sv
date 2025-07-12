module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg      dout_valid
);

    reg [2:0] cnt;          // 3-bit counter (0 to 7)
    reg [7:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt           <= 3'd0;
            data_reg      <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // Default output valid to 0 every cycle

            if (din_valid) begin
                // Store din_serial in bit position [7 - cnt]
                data_reg[7 - cnt] <= din_serial;

                if (cnt == 3'd7) begin
                    dout_parallel <= {data_reg[7:1], din_serial}; // Complete 8-bit data
                    dout_valid <= 1'b1;
                    cnt <= 3'd0; // Reset counter after 8 bits
                end else begin
                    cnt <= cnt + 3'd1;
                end
            end
        end
    end

endmodule