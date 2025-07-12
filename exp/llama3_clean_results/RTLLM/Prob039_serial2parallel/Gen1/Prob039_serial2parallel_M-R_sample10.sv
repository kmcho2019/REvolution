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
reg [1:0] state; // 2-state FSM: idle (0) and data reception (1)

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0000;
    end else if (state == 1'b1) begin
        if (cnt == 4'b1000) begin
            cnt <= 4'b0000;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
end

// Data shift logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dout_parallel_reg <= 8'b00000000;
    end else if (state == 1'b1) begin
        dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
    end
end

// FSM logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 1'b0;
        dout_valid_reg <= 1'b0;
    end else begin
        case (state)
            1'b0: begin // idle state
                if (din_valid) begin
                    state <= 1'b1;
                end
                dout_valid_reg <= 1'b0;
            end
            1'b1: begin // data reception state
                if (cnt == 4'b1000) begin
                    state <= 1'b0;
                    dout_valid_reg <= 1'b1;
                end
            end
        endcase
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule