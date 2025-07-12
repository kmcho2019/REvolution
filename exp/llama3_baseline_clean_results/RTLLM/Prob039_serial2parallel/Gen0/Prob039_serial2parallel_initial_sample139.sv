module serial2parallel(
    input clk, 
    input rst_n, 
    input din_serial, 
    input din_valid, 
    output reg [7:0] dout_parallel, 
    output reg dout_valid
);

reg [3:0] cnt;
reg [7:0] data_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        dout_valid <= 0;
        dout_parallel <= 8'h00;
        data_reg <= 8'h00;
    end else if (din_valid) begin
        if (cnt < 8) begin
            data_reg <= {data_reg[6:0], din_serial};
            cnt <= cnt + 1;
        end else begin
            cnt <= 0;
            data_reg <= 8'h00;
        end
    end else begin
        cnt <= 0;
        data_reg <= 8'h00;
    end
end

always @(posedge clk) begin
    if (cnt == 8) begin
        dout_parallel <= data_reg;
        dout_valid <= 1;
    end else begin
        dout_valid <= 0;
    end
end

endmodule