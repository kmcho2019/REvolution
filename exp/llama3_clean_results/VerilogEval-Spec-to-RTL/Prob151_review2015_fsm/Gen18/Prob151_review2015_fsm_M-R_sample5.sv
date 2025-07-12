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
reg pattern_detected;

// Combinational Logic for Output Signals and Next State
assign shift_ena = (state == SHIFT && shift_cnt <= 4);
assign counting = (state == COUNT);
assign done = (state == DONE_ACK);

always @(*) begin
    case (state)
        IDLE: begin
            if (data == 1'b1 && $past(data) == 1'b0 && $past($past(data)) == 1'b0 && $past($past($past(data))) == 1'b1) begin
                next_state = SHIFT;
            end
            else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_cnt == 4) begin
                next_state = COUNT;
            end
            else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            if (done_counting) begin
                next_state = DONE_ACK;
            end
            else begin
                next_state = COUNT;
            end
        end
        DONE_ACK: begin
            if (ack) begin
                next_state = IDLE;
            end
            else begin
                next_state = DONE_ACK;
            end
        end
    endcase
end

// Sequential Logic for State and Internal Registers Update
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_cnt <= 0;
    end
    else begin
        state <= next_state;
        if (state == SHIFT) begin
            shift_cnt <= shift_cnt + 1;
        end
        else if (state == IDLE) begin
            shift_cnt <= 0;
        end
    end
end

endmodule