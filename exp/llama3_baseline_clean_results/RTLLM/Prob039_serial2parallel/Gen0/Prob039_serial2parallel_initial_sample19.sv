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

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0000;
        shift_reg <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        cnt <= cnt + 1'b1;
        shift_reg <= {din_serial, shift_reg[7:1]};
        if (cnt == 4'b1000) begin
            dout_parallel <= shift_reg;
            dout_valid <= 1'b1;
            cnt <= 4'b0000;
        end else begin
            dout_valid <= 1'b0;
        end
    end else begin
        cnt <= 4'b0000;
        dout_valid <= 1'b0;
    end
end

endmodule