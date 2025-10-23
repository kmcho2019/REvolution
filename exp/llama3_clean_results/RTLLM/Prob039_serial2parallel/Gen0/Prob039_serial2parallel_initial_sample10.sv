module serial2parallel (
    input clk, 
    input rst_n, 
    input din_serial, 
    input din_valid, 
    output [7:0] dout_parallel, 
    output dout_valid
);

reg [7:0] dout_parallel_reg;
reg dout_valid_reg;
reg [2:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dout_parallel_reg <= 8'b0;
        dout_valid_reg <= 1'b0;
        cnt <= 3'b0;
    end else if (din_valid) begin
        if (cnt == 3'b111) begin
            dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
            dout_valid_reg <= 1'b1;
            cnt <= 3'b0;
        end else begin
            dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
            dout_valid_reg <= 1'b0;
            cnt <= cnt + 1'b1;
        end
    end else begin
        if (cnt == 3'b111) begin
            dout_valid_reg <= 1'b0;
        end
        cnt <= 3'b0;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule