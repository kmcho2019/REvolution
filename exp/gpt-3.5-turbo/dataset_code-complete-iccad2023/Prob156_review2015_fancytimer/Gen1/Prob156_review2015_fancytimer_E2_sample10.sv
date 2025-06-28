module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

typedef enum logic [3:0] {
    SEARCH_START, READ_DELAY, COUNTING, TIMER_DONE
} state_t;

reg [1:0] state, next_state;
reg [3:0] delay;
reg [3:0] remaining_count;
reg [11:0] counter;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= SEARCH_START;
        counting <= 0;
        done <= 0;
        delay <= 4'b0;
        remaining_count <= 4'b0;
        counter <= 12'b0;
    end
    else begin
        state <= next_state;
    end
end

always_comb begin
    count = counting ? remaining_count : 4'b0;
end

always_comb begin
    next_state = state;
    counting = 0;

    case(state)
        SEARCH_START: begin
            if (data == 4'b1101) begin
                next_state = READ_DELAY;
            end
        end
        READ_DELAY: begin
            delay = data;
            remaining_count = delay;
            counter = 12'b0;
            next_state = COUNTING;
        end
        COUNTING: begin
            if (counter < (remaining_count + 1) * 1000 - 1) begin
                counter = counter + 1;
                if (counter % 1000 == 0 && remaining_count > 0) begin
                    remaining_count = remaining_count - 1;
                end
            end
            else begin
                next_state = TIMER_DONE;
            end
        end
        TIMER_DONE: begin
            done = 1;
            if (ack) begin
                done = 0;
                next_state = SEARCH_START;
            end
        end
    endcase
end

endmodule