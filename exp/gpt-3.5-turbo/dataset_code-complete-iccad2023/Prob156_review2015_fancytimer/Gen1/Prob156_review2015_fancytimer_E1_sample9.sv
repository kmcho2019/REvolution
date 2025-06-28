module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

typedef enum logic [2:0] {
    SEARCH_START,
    DETECTED,
    READ_DELAY,
    COUNTING,
    TIMER_DONE
} state_type;

reg [3:0] shift_reg;
reg [2:0] delay;
reg [15:0] countdown;
reg [3:0] remaining_count;

state_type state;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= SEARCH_START;
        shift_reg <= 4'b0;
        delay <= 0;
        counting <= 0;
        countdown <= 0;
        done <= 0;
    end else begin
        case (state)
            SEARCH_START: begin
                if (data == 4'b1101) begin
                    shift_reg <= {shift_reg[2:0], data};
                    delay <= shift_reg[2:0];
                    state <= DETECTED;
                end
            end
            DETECTED: begin
                state <= READ_DELAY;
            end
            READ_DELAY: begin
                state <= COUNTING;
            end
            COUNTING: begin
                if (countdown == 0) begin
                    remaining_count <= remaining_count - 1;
                    countdown <= 1000;
                    if (remaining_count == 0) begin
                        state <= TIMER_DONE;
                    end
                end else begin
                    countdown <= countdown - 1;
                end
            end
            TIMER_DONE: begin
                done <= 1;
                counting <= 0;
                if (ack) begin
                    done <= 0;
                    state <= SEARCH_START;
                end
            end
        endcase

        if (state == COUNTING) begin
            counting <= 1;
            count <= remaining_count;
        else
            counting <= 0;
            count <= 4'b0;
        end
    end
end

endmodule