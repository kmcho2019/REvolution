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
reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;
        dout_parallel_reg <= 8'd0;
        dout_valid_reg <= 1'd0;
    end else if (din_valid) begin
        if (cnt == 4'd8) begin
            cnt <= 4'd0;
            dout_valid_reg <= 1'd1;
        end else begin
            cnt <= cnt + 1'd1;
            dout_valid_reg <= 1'd0;
        end
        case (cnt)
            4'd1: dout_parallel_reg <= {din_serial, 7'd0};
            4'd2: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:0]};
            4'd3: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:1]};
            4'd4: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:2]};
            4'd5: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:3]};
            4'd6: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:4]};
            4'd7: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:5]};
            4'd8: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:6]};
            default: dout_parallel_reg <= 8'd0;
        endcase
    end else begin
        cnt <= cnt;
        dout_parallel_reg <= dout_parallel_reg;
        dout_valid_reg <= dout_valid_reg;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule