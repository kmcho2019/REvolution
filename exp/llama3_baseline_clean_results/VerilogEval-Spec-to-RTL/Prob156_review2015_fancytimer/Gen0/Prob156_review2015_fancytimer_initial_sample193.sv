module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

// Define states
enum logic [3:0] {
    IDLE = 4'd0,
    PATTERN_DETECT = 4'd1,
    SHIFT = 4'd2,
    COUNT = 4'd3,
    DONE = 4'd4
} state, next_state;

// Define internal signals
logic [3:0] delay;
logic [9:0] counter;
logic [3:0] remaining_time;

always_comb begin
    next_state = state;
    case(state)
        IDLE: begin
            if (reset) next_state = IDLE;
            else if (data == 1'b1) next_state = PATTERN_DETECT;
            else next_state = IDLE;
        end
        PATTERN_DETECT: begin
            if (reset) next_state = IDLE;
            else if (data == 1'b0) next_state = PATTERN_DETECT;
            else if (data == 1'b1) next_state = SHIFT;
            else next_state = PATTERN_DETECT;
        end
        SHIFT: begin
            if (reset) next_state = IDLE;
            else if (counter == 4'd0) next_state = COUNT;
            else next_state = SHIFT;
        end
        COUNT: begin
            if (reset) next_state = IDLE;
            else if (counter == 10'd0) next_state = DONE;
            else next_state = COUNT;
        end
        DONE: begin
            if (reset) next_state = IDLE;
            else if (ack) next_state = IDLE;
            else next_state = DONE;
        end
        default: next_state = IDLE;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) state <= IDLE;
    else state <= next_state;
    
    case(state)
        IDLE: begin
            counting <= 1'b0;
            done <= 1'b0;
            counter <= 10'd0;
        end
        PATTERN_DETECT: begin
            if (data == 1'b0) delay[3] <= 1'b1;
            else if (data == 1'b1) delay[3] <= 1'b0;
        end
        SHIFT: begin
            if (counter == 4'd0) delay[2] <= data;
            else if (counter == 4'd1) delay[1] <= data;
            else if (counter == 4'd2) delay[0] <= data;
            counter <= counter + 1'd1;
            if (counter == 4'd4) counter <= (delay + 1'd1) * 10'd1000;
        end
        COUNT: begin
            counter <= counter - 1'd1;
            counting <= 1'b1;
            if (counter < 10'd1000) remaining_time <= delay;
            else if (counter < 10'd2000) remaining_time <= delay - 1'd1;
            else if (counter < 10'd3000) remaining_time <= delay - 2'd2;
            else if (counter < 10'd4000) remaining_time <= delay - 3'd3;
            else remaining_time <= delay - 4'd4;
        end
        DONE: begin
            done <= 1'b1;
            counting <= 1'b0;
        end
        default: ;
    endcase
end

assign count = (state == COUNT) ? remaining_time : 4'd0;

endmodule