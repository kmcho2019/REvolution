module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [7:0] shift_reg;
reg [2:0] cnt;
reg clk_enable;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_reg <= 8'b00000000;
        cnt <= 3'b000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        shift_reg <= {shift_reg[6:0], din_serial};
        cnt <= cnt + 1'b1;
        if (cnt == 3'b111) begin
            dout_valid <= 1'b1;
            cnt <= 3'b000;
        end else begin
            dout_valid <= 1'b0;
        end
    end else begin
        dout_valid <= 1'b0;
    end
end

always @(posedge clk) begin
    if (dout_valid) begin
        dout_parallel <= shift_reg;
    end
end

endmodule