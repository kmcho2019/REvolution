module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

parameter IDLE = 3'b000;
parameter SHIFT = 3'b001;
parameter COUNT = 3'b010;
parameter DONE_ACK = 3'b100;

reg [2:0] state, next_state;
reg [3:0] shift_cnt;
reg [3:0] data_reg;

assign shift_ena = (state == SHIFT);
assign counting = (state == COUNT);
assign done = (state == DONE_ACK);

always @(*) begin
    next_state = state; // Default: stay in the current state
    case (state)
        IDLE: begin
            if (data_reg == 4'b1101 && data == 1'b1) begin
                next_state = SHIFT;
            end
        end
        SHIFT: begin
            if (shift_cnt == 4) begin
                next_state = COUNT;
            end
        end
        COUNT: begin
            if (done_counting) begin
                next_state = DONE_ACK;
            end
        end
        DONE_ACK: begin
            if (ack) begin
                next_state = IDLE;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_cnt <= 0;
        data_reg <= 0;
    end
    else begin
        state <= next_state;
        data_reg <= {data, data_reg[3:1]};
        if (state == SHIFT && shift_cnt < 4) begin
            shift_cnt <= shift_cnt + 1;
        end
        else if (state == COUNT || state == DONE_ACK) begin
            shift_cnt <= 0;
        end
    end
end

endmodule