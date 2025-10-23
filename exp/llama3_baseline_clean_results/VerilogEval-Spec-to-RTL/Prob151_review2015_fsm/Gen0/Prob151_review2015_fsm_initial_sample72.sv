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

reg [3:0] state;
reg [3:0] nextState;
reg [3:0] shift_cnt;

localparam IDLE = 4'd0;
localparam SHIFT = 4'd1;
localparam COUNTING = 4'd2;
localparam DONE = 4'd3;
localparam ACK_WAIT = 4'd4;

reg [3:0] data_shifted;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_cnt <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        state <= nextState;
        if (nextState == SHIFT) begin
            shift_cnt <= 0;
        end else if (nextState == COUNTING) begin
            counting <= 1;
        end else if (nextState == DONE) begin
            done <= 1;
        end
        if (nextState == IDLE) begin
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
        end
        if (state == SHIFT) begin
            shift_cnt <= shift_cnt + 1;
        end
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (data_shifted == 4'd13) begin // 1101
                nextState = SHIFT;
            end else begin
                nextState = IDLE;
            end
            shift_ena = 0;
            counting = 0;
            done = 0;
        end
        SHIFT: begin
            shift_ena = 1;
            if (shift_cnt == 4) begin
                nextState = COUNTING;
            end else begin
                nextState = SHIFT;
            end
        end
        COUNTING: begin
            shift_ena = 0;
            if (done_counting) begin
                nextState = DONE;
            end else begin
                nextState = COUNTING;
            end
        end
        DONE: begin
            shift_ena = 0;
            if (ack) begin
                nextState = ACK_WAIT;
            end else begin
                nextState = DONE;
            end
        end
        ACK_WAIT: begin
            shift_ena = 0;
            nextState = IDLE;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        data_shifted <= 0;
    end else if (state == IDLE) begin
        data_shifted <= {data_shifted[2:0], data};
    end
end

endmodule