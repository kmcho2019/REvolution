module serial2parallel (
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
);

    reg [7:0] data_reg;
    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt          <= 4'd0;
            data_reg     <= 8'd0;
            dout_parallel<= 8'd0;
            dout_valid   <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default deassert

            if (din_valid) begin
                data_reg[7 - cnt] <= din_serial; // Store serial bit at the MSB-first position

                if (cnt == 4'd7) begin
                    dout_parallel <= {data_reg[7:1], din_serial}; // Complete 8-bit word assembled
                    dout_valid <= 1'b1; // output valid for one clock cycle
                    cnt <= 4'd0; // reset counter
                end else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end

endmodule