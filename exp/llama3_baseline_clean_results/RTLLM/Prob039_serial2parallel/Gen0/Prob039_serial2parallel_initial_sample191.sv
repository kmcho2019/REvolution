module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] dout_parallel;
reg dout_valid;
reg [3:0] cnt;
reg [7:0] data_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0000;
        dout_valid <= 1'b0;
        data_reg <= 8'b00000000;
    end else if (din_valid) begin
        if (cnt == 4'b1000) begin
            cnt <= 4'b0000;
            dout_parallel <= data_reg;
            dout_valid <= 1'b1;
        end else begin
            cnt <= cnt + 1;
            data_reg <= {data_reg[6:0], din_serial};
            dout_valid <= 1'b0;
        end
    end else begin
        cnt <= cnt;
        data_reg <= data_reg;
        dout_valid <= 1'b0;
    end
end

endmodule