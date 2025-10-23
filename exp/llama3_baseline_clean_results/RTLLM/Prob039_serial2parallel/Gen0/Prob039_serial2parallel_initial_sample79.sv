module serial2parallel(
    input  clk,
    input  rst_n,
    input  din_serial,
    input  din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] dout_parallel_reg;
reg [2:0] cnt;
reg dout_valid_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        dout_parallel_reg <= 8'b0;
        dout_valid_reg <= 1'b0;
    end
    else if (din_valid) begin
        if (cnt == 3'b111) begin
            // If 8 bits have been received, output the data
            dout_valid_reg <= 1'b1;
            cnt <= 3'b000;
        end
        else begin
            // If less than 8 bits have been received, shift the data
            dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            cnt <= cnt + 1'b1;
            dout_valid_reg <= 1'b0;
        end
    end
    else begin
        cnt <= cnt;
        dout_parallel_reg <= dout_parallel_reg;
        dout_valid_reg <= 1'b0;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule