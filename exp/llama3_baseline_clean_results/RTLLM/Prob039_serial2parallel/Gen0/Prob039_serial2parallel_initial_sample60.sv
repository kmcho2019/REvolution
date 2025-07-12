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

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dout_parallel_reg <= 8'h00;
        cnt <= 4'h0;
        dout_valid_reg <= 1'b0;
    end else if (din_valid) begin
        if (cnt < 4'd7) begin
            dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
            cnt <= cnt + 1'b1;
            dout_valid_reg <= 1'b0;
        end else begin
            dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
            cnt <= 4'h0;
            dout_valid_reg <= 1'b1;
        end
    end else begin
        dout_valid_reg <= 1'b0;
    end
end

endmodule