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
reg [3:0] cnt_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_reg <= 4'b0000;
        dout_parallel_reg <= 8'b00000000;
        dout_valid_reg <= 1'b0;
    end else if (din_valid) begin
        if (cnt_reg == 4'b1000) begin
            cnt_reg <= 4'b0000;
            dout_valid_reg <= 1'b1;
        end else begin
            cnt_reg <= cnt_reg + 1;
            dout_valid_reg <= 1'b0;
        end
        case (cnt_reg)
            4'b0000: dout_parallel_reg <= {din_serial, 7'b0000000};
            4'b0001: dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            4'b0010: dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            4'b0011: dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            4'b0100: dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            4'b0101: dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            4'b0110: dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            4'b0111: dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            4'b1000: dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
        endcase
    end else begin
        cnt_reg <= cnt_reg;
        dout_parallel_reg <= dout_parallel_reg;
        if (cnt_reg == 4'b1000) begin
            dout_valid_reg <= 1'b1;
        end else begin
            dout_valid_reg <= 1'b0;
        end
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule