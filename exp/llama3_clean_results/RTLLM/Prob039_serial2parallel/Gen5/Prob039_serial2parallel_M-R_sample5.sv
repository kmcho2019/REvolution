module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;
reg [7:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0000;
        shift_reg <= 8'b00000000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        if (cnt < 4'b1000) begin
            shift_reg <= {shift_reg[6:0], din_serial};
            cnt <= cnt + 1'b1;
        end else begin
            cnt <= 4'b0000;
            shift_reg <= 8'b00000000;
        end
    end else begin
        cnt <= cnt;
        shift_reg <= shift_reg;
    end
end

assign dout_parallel = (cnt == 4'b1000) ? shift_reg : 8'b00000000;
assign dout_valid = (cnt == 4'b1000) ? 1'b1 : 1'b0;

endmodule