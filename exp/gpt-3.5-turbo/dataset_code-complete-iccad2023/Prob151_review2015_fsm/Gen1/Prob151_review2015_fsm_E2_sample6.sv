module TopModule (
  input clk,
  input reset,
  input data,
  output reg shift_ena,
  output reg counting,
  input done_counting,
  output reg done,
  input ack
);

localparam IDLE = 3'b000;
localparam DETECT_PATTERN = 3'b001;
localparam SHIFT_DELAY = 3'b010;
localparam DETECT_DONE_COUNTING = 3'b011;
localparam NOTIFY_USER = 3'b100;
localparam WAIT_FOR_ACK = 3'b101;

reg [2:0] state, next_state;
reg [3:0] shift_counter;

always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_counter <= 0;
    end
    else begin
        state <= next_state;
    end
end

always @* begin
    shift_ena = 0;
    counting = 0;
    done = 0;
    next_state = state;
    case (state)
        IDLE: begin
            if (data == 4'b1101) begin
                next_state = DETECT_PATTERN;
            end
        end
        DETECT_PATTERN: begin
            next_state = SHIFT_DELAY;
        end
        SHIFT_DELAY: begin
            shift_ena = 1;
            if (shift_counter == 4) begin
                next_state = DETECT_DONE_COUNTING;
            end
            else begin
                shift_counter <= shift_counter + 1;
            end
        end
        DETECT_DONE_COUNTING: begin
            counting = 1;
            if (done_counting) begin
                next_state = NOTIFY_USER;
            end
        end
        NOTIFY_USER: begin
            done = 1;
            next_state = WAIT_FOR_ACK;
        end
        WAIT_FOR_ACK: begin
            if (ack) begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule