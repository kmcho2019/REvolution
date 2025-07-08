module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg      dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg    <= 8'b0;
            cnt          <= 4'b0;
            dout_parallel <= 8'b0;
            dout_valid   <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default 0 unless set below

            if (din_valid) begin
                // Shift din_serial into shift_reg from MSB to LSB
                shift_reg <= {shift_reg[6:0], din_serial};
                if (cnt == 4'd7) begin
                    dout_parallel <= {shift_reg[6:0], din_serial}; // output assembled 8 bits
                    dout_valid <= 1'b1;
                    cnt <= 4'b0;
                end else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end

endmodule