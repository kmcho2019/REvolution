module serial2parallel (
    input            clk,
    input            rst_n,
    input            din_serial,
    input            din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [2:0] cnt;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt           <= 3'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // Default to 0 each cycle
            if (din_valid) begin
                dout_parallel <= {din_serial, dout_parallel[7:1]};
                if (cnt == 3'd7) begin
                    dout_valid <= 1'b1;
                    cnt <= 3'd0;
                end else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end

endmodule