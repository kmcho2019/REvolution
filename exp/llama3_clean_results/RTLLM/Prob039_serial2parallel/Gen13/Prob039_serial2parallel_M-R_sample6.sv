module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;
reg [7:0] dout_parallel_reg;
reg [2:0] state; // 0: idle, 1: receiving, 2: output

// State machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        cnt <= 4'b0000;
        dout_parallel_reg <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            0: begin // idle
                if (din_valid) begin
                    state <= 1;
                    cnt <= 4'b0001;
                    dout_parallel_reg <= {7'b0000000, din_serial};
                end
            end
            1: begin // receiving
                if (din_valid && cnt < 4'b1000) begin
                    cnt <= cnt + 1'b1;
                    dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
                end else if (cnt == 4'b1000) begin
                    state <= 2;
                end
            end
            2: begin // output
                state <= 0;
                dout_valid <= 1'b1;
            end
        endcase
    end
end

// Output logic
always @(posedge clk) begin
    if (state == 2) begin
        dout_parallel <= dout_parallel_reg;
    end else begin
        dout_valid <= 1'b0;
    end
end

endmodule