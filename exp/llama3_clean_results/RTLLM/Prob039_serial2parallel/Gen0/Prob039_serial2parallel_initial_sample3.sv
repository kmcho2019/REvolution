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
        cnt <= 4'b0000;
        data_reg <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        case (cnt)
            4'b0000: data_reg <= {din_serial, 7'b0000000};
            4'b0001: data_reg <= {data_reg[6:0], din_serial};
            4'b0010: data_reg <= {data_reg[6:0], din_serial};
            4'b0011: data_reg <= {data_reg[6:0], din_serial};
            4'b0100: data_reg <= {data_reg[6:0], din_serial};
            4'b0101: data_reg <= {data_reg[6:0], din_serial};
            4'b0110: data_reg <= {data_reg[6:0], din_serial};
            4'b0111: data_reg <= {data_reg[6:0], din_serial};
        endcase
        cnt <= cnt + 1'b1;
        if (cnt == 4'b1000) begin
            cnt <= 4'b0000;
            dout_parallel <= data_reg;
            dout_valid <= 1'b1;
        end else begin
            dout_valid <= 1'b0;
        end
    end else begin
        cnt <= cnt;
        data_reg <= data_reg;
        dout_valid <= 1'b0;
    end
end

endmodule