module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [7:0] shift_reg;
reg [3:0] cnt;
reg cnt_en;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_reg <= 8'b0;
        cnt <= 4'b0000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        cnt_en <= 1'b1;
        shift_reg <= {shift_reg[6:0], din_serial};
        if (cnt == 8) begin
            cnt <= 4'b0000;
            dout_valid <= 1'b1;
        end else begin
            cnt <= cnt + 1;
            dout_valid <= 1'b0;
        end
    end else begin
        cnt_en <= 1'b0;
        dout_valid <= 1'b0;
    end
end

assign dout_parallel = shift_reg;

endmodule