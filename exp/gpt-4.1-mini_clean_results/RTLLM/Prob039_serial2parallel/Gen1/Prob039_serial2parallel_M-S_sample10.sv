module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg      dout_valid
);

    reg [2:0] cnt;
    reg [7:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            shift_reg <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else if (din_valid) begin
            shift_reg <= {shift_reg[6:0], din_serial};
            if (cnt == 3'd7) begin
                dout_parallel <= {shift_reg[6:0], din_serial};
                dout_valid <= 1'b1;
                cnt <= 3'd0;
            end else begin
                cnt <= cnt + 1'b1;
                dout_valid <= 1'b0;
            end
        end else begin
            dout_valid <= 1'b0;
        end
    end

endmodule