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
reg dout_valid_reg;

// State Machine States
enum logic [1:0] {IDLE, RECEIVING, OUTPUT_VALID} state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        cnt <= 4'b0000;
        dout_parallel_reg <= 8'b00000000;
        dout_valid_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (din_valid) begin
                    state <= RECEIVING;
                    cnt <= 1'b1;
                    dout_parallel_reg <= {7'b0, din_serial};
                end else begin
                    state <= IDLE;
                end
            end
            RECEIVING: begin
                if (cnt < 4'b1000 && din_valid) begin
                    state <= RECEIVING;
                    cnt <= cnt + 1'b1;
                    dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
                end else if (cnt == 4'b1000) begin
                    state <= OUTPUT_VALID;
                end else begin
                    state <= IDLE;
                end
            end
            OUTPUT_VALID: begin
                state <= IDLE;
            end
        endcase
        dout_valid_reg <= (state == OUTPUT_VALID) ? 1'b1 : 1'b0;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule