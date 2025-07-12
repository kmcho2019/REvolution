module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] dout_parallel_reg;
reg [3:0] cnt;
reg dout_valid_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dout_parallel_reg <= 8'd0;
        cnt <= 4'd0;
        dout_valid_reg <= 1'b0;
    end else if (din_valid) begin
        if (cnt < 4'd8) begin
            // Shift the received bit into the corresponding position in dout_parallel_reg
            dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            cnt <= cnt + 1'b1;
        end
        if (cnt == 4'd8) begin
            // Set dout_valid_reg to 1 after 8 bits have been received
            dout_valid_reg <= 1'b1;
        end
    end else begin
        if (dout_valid_reg) begin
            // Reset dout_valid_reg and cnt after one clock cycle
            dout_valid_reg <= 1'b0;
            cnt <= 4'd0;
        end
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule