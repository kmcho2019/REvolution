module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg      dout_valid
);

    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt          <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid   <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // default

            if (din_valid) begin
                // Shift bits left by 1 and input the new bit at LSB
                dout_parallel <= {dout_parallel[6:0], din_serial};
                
                if (cnt == 4'd7) begin
                    dout_valid <= 1'b1;  // 8 bits received
                    cnt <= 4'd0;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule