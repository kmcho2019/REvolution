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
reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dout_parallel_reg <= 8'b0;
        dout_valid_reg <= 1'b0;
        cnt <= 4'b0;
    end else if (din_valid) begin
        if (cnt == 4'b1000) begin
            cnt <= 4'b0;
            dout_valid_reg <= 1'b1;
        end else begin
            cnt <= cnt + 1'b1;
            dout_valid_reg <= 1'b0;
        end
        case (cnt)
            4'b0000: dout_parallel_reg <= {din_serial, 7'b0};
            4'b0001: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:0]};
            4'b0010: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:1]};
            4'b0011: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:2]};
            4'b0100: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:3]};
            4'b0101: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:4]};
            4'b0110: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:5]};
            4'b0111: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:6]};
            default: dout_parallel_reg <= dout_parallel_reg;
        endcase
    end else begin
        cnt <= cnt;
        dout_valid_reg <= 1'b0;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule