module serial2parallel (
    input            clk,
    input            rst_n,
    input            din_serial,
    input            din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [3:0] cnt;
    reg [7:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt           <= 4'd0;
            data_reg      <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // Default deassertion

            if (din_valid) begin
                // Store din_serial into bit (7 - cnt) so MSB is first received bit
                data_reg[7 - cnt] <= din_serial;
                cnt <= cnt + 1;

                if (cnt == 4'd7) begin
                    dout_parallel <= {data_reg[7:1], din_serial}; // Form full 8-bit word
                    dout_valid    <= 1'b1;
                    cnt           <= 4'd0;
                end
            end
        end
    end

endmodule