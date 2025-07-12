module serial2parallel(
    input clk, 
    input rst_n, 
    input din_serial, 
    input din_valid, 
    output [7:0] dout_parallel, 
    output dout_valid
);

reg [7:0] dout_parallel_reg;
reg dout_valid_reg;
reg [3:0] cnt_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Initialize counter, output data, and validity signal on reset
        cnt_reg <= 4'd0;
        dout_parallel_reg <= 8'd0;
        dout_valid_reg <= 1'd0;
    end else if (din_valid) begin
        // Shift input bit into output data and increment counter
        if (cnt_reg < 4'd8) begin
            dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            cnt_reg <= cnt_reg + 1'd1;
        end
        // Set validity signal to 1 when 8 bits have been received
        if (cnt_reg == 4'd8) begin
            dout_valid_reg <= 1'd1;
        end
        // Reset counter and validity signal when counter overflows
        if (cnt_reg > 4'd8) begin
            cnt_reg <= 4'd0;
            dout_valid_reg <= 1'd0;
        end
    end else begin
        // Reset counter and validity signal when input data is not valid
        cnt_reg <= 4'd0;
        dout_valid_reg <= 1'd0;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = (cnt_reg == 4'd8) ? 1'd1 : 1'd0;

endmodule