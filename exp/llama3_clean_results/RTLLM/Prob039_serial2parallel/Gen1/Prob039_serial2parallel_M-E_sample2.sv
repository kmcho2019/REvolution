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
reg [1:0] state; // 0: idle, 1: data collection, 2: output
reg dout_valid_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'd0;
        cnt <= 4'd0;
        dout_parallel_reg <= 8'd0;
        dout_valid_reg <= 1'd0;
    end else begin
        case (state)
            2'd0: begin // idle
                if (din_valid) begin
                    state <= 2'd1;
                    cnt <= 4'd1;
                    dout_parallel_reg <= {din_serial, 7'd0};
                    dout_valid_reg <= 1'd0;
                end
            end
            2'd1: begin // data collection
                if (cnt < 4'd8) begin
                    if (din_valid) begin
                        cnt <= cnt + 1'd1;
                        dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
                    end
                end else begin
                    state <= 2'd2;
                    dout_valid_reg <= 1'd1;
                end
            end
            2'd2: begin // output
                state <= 2'd0;
                dout_valid_reg <= 1'd0;
            end
        endcase
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule