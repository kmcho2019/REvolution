module serial2parallel (
    input            clk,
    input            rst_n,
    input            din_serial,
    input            din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] data_reg;
    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg      <= 8'b0;
            cnt           <= 4'd0;
            dout_parallel <= 8'b0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default clear output valid

            if (din_valid) begin
                // Store din_serial bit into data_reg at position (7 - cnt)
                data_reg[7 - cnt] <= din_serial;

                if (cnt == 4'd7) begin
                    dout_parallel <= {data_reg[7:1], din_serial}; // latch full 8-bit data MSB first
                    dout_valid    <= 1'b1;
                    cnt           <= 4'd0;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule