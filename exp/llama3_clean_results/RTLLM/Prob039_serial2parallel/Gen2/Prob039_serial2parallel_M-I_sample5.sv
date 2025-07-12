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
reg [2:0] state; // 0: idle, 1-7: data collection, 8: output

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 3'd0;
        dout_parallel_reg <= 8'd0;
        dout_valid_reg <= 1'd0;
    end else begin
        case (state)
            3'd0: begin // idle
                if (din_valid) begin
                    state <= 3'd1;
                    dout_parallel_reg <= {din_serial, 7'd0};
                    dout_valid_reg <= 1'd0;
                end
            end
            3'd1: begin // data collection state 1
                if (din_valid) begin
                    state <= 3'd2;
                    dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
                end
            end
            3'd2: begin // data collection state 2
                if (din_valid) begin
                    state <= 3'd3;
                    dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
                end
            end
            3'd3: begin // data collection state 3
                if (din_valid) begin
                    state <= 3'd4;
                    dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
                end
            end
            3'd4: begin // data collection state 4
                if (din_valid) begin
                    state <= 3'd5;
                    dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
                end
            end
            3'd5: begin // data collection state 5
                if (din_valid) begin
                    state <= 3'd6;
                    dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
                end
            end
            3'd6: begin // data collection state 6
                if (din_valid) begin
                    state <= 3'd7;
                    dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
                end
            end
            3'd7: begin // data collection state 7
                if (din_valid) begin
                    state <= 3'd8;
                    dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
                end
            end
            3'd8: begin // output state
                dout_valid_reg <= 1'd1;
                state <= 3'd0;
            end
        endcase
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule