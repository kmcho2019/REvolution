module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] fifo;
reg [2:0] fill_level;
reg [7:0] dout_parallel_reg;
reg dout_valid_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        fifo <= 8'b00000000;
        fill_level <= 3'b000;
        dout_parallel_reg <= 8'b00000000;
        dout_valid_reg <= 1'b0;
    end else begin
        if (din_valid) begin
            fifo <= {fifo[6:0], din_serial};
            if (fill_level == 3'b111) begin
                fill_level <= 3'b000;
                dout_parallel_reg <= fifo;
                dout_valid_reg <= 1'b1;
            end else begin
                fill_level <= fill_level + 1'b1;
                if (fill_level == 3'b111) begin
                    dout_valid_reg <= 1'b1;
                end else begin
                    dout_valid_reg <= 1'b0;
                end
            end
        end else if (fill_level == 3'b111) begin
            fill_level <= 3'b000;
            dout_valid_reg <= 1'b0;
        end
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule