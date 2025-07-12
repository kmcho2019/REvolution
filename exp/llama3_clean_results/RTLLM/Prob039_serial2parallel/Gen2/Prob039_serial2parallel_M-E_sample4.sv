module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] dout_parallel_reg;
reg [2:0] cnt_reg;
reg [7:0] shift_reg;
reg dout_valid_reg;
reg [1:0] state_reg;

localparam IDLE = 2'd0;
localparam CONVERTING = 2'd1;
localparam DONE = 2'd2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state_reg <= IDLE;
        cnt_reg <= 3'd0;
        shift_reg <= 8'd0;
        dout_valid_reg <= 1'd0;
        dout_parallel_reg <= 8'd0;
    end else begin
        case (state_reg)
            IDLE: begin
                if (din_valid) begin
                    state_reg <= CONVERTING;
                    cnt_reg <= 3'd1;
                    shift_reg <= {din_serial, 7'd0};
                    dout_valid_reg <= 1'd0;
                end else begin
                    state_reg <= IDLE;
                    cnt_reg <= 3'd0;
                    dout_valid_reg <= 1'd0;
                end
            end
            CONVERTING: begin
                if (din_valid) begin
                    cnt_reg <= cnt_reg + 1'd1;
                    shift_reg <= {din_serial, shift_reg[7:1]};
                    if (cnt_reg == 3'd7) begin
                        state_reg <= DONE;
                    end else begin
                        state_reg <= CONVERTING;
                    end
                end else begin
                    state_reg <= IDLE;
                    cnt_reg <= 3'd0;
                    dout_valid_reg <= 1'd0;
                end
            end
            DONE: begin
                state_reg <= IDLE;
                dout_parallel_reg <= shift_reg;
                dout_valid_reg <= 1'd1;
            end
        endcase
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule