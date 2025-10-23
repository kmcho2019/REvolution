module serial2parallel (
    input            clk,
    input            rst_n,
    input            din_serial,
    input            din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [2:0] cnt;  // 3-bit counter sufficient for counting 0 to 7

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt           <= 3'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            if (din_valid) begin
                dout_parallel <= {din_serial, dout_parallel[7:1]};  // shift right, input at MSB
                if (cnt == 3'd7) begin
                    dout_valid <= 1'b1;  // output valid after 8 bits
                    cnt <= 3'd0;
                end else begin
                    dout_valid <= 1'b0;
                    cnt <= cnt + 3'd1;
                end
            end else begin
                dout_valid <= 1'b0;  // keep dout_valid low when no valid input
            end
        end
    end

endmodule