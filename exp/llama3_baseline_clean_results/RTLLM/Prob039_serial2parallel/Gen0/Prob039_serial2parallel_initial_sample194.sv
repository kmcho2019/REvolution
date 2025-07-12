module serial2parallel (
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
        cnt <= 4'b0000;
        dout_parallel_reg <= 8'b00000000;
        dout_valid_reg <= 1'b0;
    end else if (din_valid) begin
        case (cnt)
            4'b0000: begin
                dout_parallel_reg[7] <= din_serial;
                cnt <= cnt + 1'b1;
            end
            4'b0001: begin
                dout_parallel_reg[6] <= din_serial;
                cnt <= cnt + 1'b1;
            end
            4'b0010: begin
                dout_parallel_reg[5] <= din_serial;
                cnt <= cnt + 1'b1;
            end
            4'b0011: begin
                dout_parallel_reg[4] <= din_serial;
                cnt <= cnt + 1'b1;
            end
            4'b0100: begin
                dout_parallel_reg[3] <= din_serial;
                cnt <= cnt + 1'b1;
            end
            4'b0101: begin
                dout_parallel_reg[2] <= din_serial;
                cnt <= cnt + 1'b1;
            end
            4'b0110: begin
                dout_parallel_reg[1] <= din_serial;
                cnt <= cnt + 1'b1;
            end
            4'b0111: begin
                dout_parallel_reg[0] <= din_serial;
                cnt <= 4'b0000;
                dout_valid_reg <= 1'b1;
            end
            default: begin
                cnt <= cnt;
                dout_parallel_reg <= dout_parallel_reg;
                dout_valid_reg <= dout_valid_reg;
            end
        endcase
    end else if (~din_valid && (cnt == 4'b0111)) begin
        dout_valid_reg <= 1'b0;
        cnt <= 4'b0000;
    end else begin
        cnt <= cnt;
        dout_parallel_reg <= dout_parallel_reg;
        dout_valid_reg <= dout_valid_reg;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule