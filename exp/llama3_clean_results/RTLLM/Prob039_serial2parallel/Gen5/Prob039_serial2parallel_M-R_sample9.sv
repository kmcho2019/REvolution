module counter(
    input clk,
    input rst_n,
    input en,
    output reg [3:0] cnt
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0000;
    end else if (en) begin
        if (cnt == 4'b1000) begin
            cnt <= 4'b0000;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
end

endmodule

module shift_register(
    input clk,
    input rst_n,
    input din,
    input en,
    output reg [7:0] dout
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dout <= 8'b00000000;
    end else if (en) begin
        dout <= {dout[6:0], din};
    end
end

endmodule

module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [1:0] state;
reg [3:0] cnt;
reg [7:0] dout_parallel_reg;

counter u_counter(
    .clk(clk),
    .rst_n(rst_n),
    .en(state == 2'b01),
    .cnt(cnt)
);

shift_register u_shift_register(
    .clk(clk),
    .rst_n(rst_n),
    .din(din_serial),
    .en(state == 2'b01 && din_valid),
    .dout(dout_parallel_reg)
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
        dout_valid <= 1'b0;
    end else begin
        case(state)
            2'b00: begin
                if (din_valid) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin
                if (cnt == 4'b1000) begin
                    state <= 2'b00;
                    dout_valid <= 1'b1;
                end
            end
        endcase
    end
end

assign dout_parallel = dout_parallel_reg;

endmodule