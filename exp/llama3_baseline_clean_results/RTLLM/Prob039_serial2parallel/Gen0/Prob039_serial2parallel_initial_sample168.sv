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
        dout_parallel_reg <= 8'h00;
        dout_valid_reg <= 1'b0;
        cnt <= 4'h0;
    end else if (din_valid) begin
        if (cnt == 4'h8) begin
            cnt <= 4'h0;
            dout_valid_reg <= 1'b1;
        end else begin
            cnt <= cnt + 1;
            dout_valid_reg <= 1'b0;
        end
        case (cnt)
            4'h1: dout_parallel_reg <= {din_serial, 7'h00};
            4'h2: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:0], 1'b0};
            4'h3: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:0], 2'b00};
            4'h4: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:0], 3'b000};
            4'h5: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:0], 4'b0000};
            4'h6: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:0], 5'b00000};
            4'h7: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:0], 6'b000000};
            4'h8: dout_parallel_reg <= {din_serial, dout_parallel_reg[6:0], 7'b0000000};
        endcase
    end else begin
        dout_valid_reg <= 1'b0;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule