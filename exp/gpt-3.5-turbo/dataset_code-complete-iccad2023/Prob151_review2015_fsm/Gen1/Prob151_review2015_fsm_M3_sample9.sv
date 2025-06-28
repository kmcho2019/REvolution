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

reg [2:0] state, next_state;

// State definitions
parameter IDLE = 3'b000;
parameter DETECT_PATTERN = 3'b001;
parameter SHIFT_DELAY = 3'b010;
parameter WAIT_FOR_ACK = 3'b011;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        state <= next_state;
    end
end

always @* begin
    case (state)
        IDLE: begin
            if (data == 4'b1101) begin
                next_state = DETECT_PATTERN;
            end
        end
        DETECT_PATTERN: begin
            // Shift in 4 bits
            next_state = SHIFT_DELAY;
        end
        SHIFT_DELAY: begin
            next_state = WAIT_FOR_ACK;
        end
        WAIT_FOR_ACK: begin
            if (ack) begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
    
    shift_ena = (state == SHIFT_DELAY);
    counting = (state == WAIT_FOR_ACK);
    done = (state == WAIT_FOR_ACK);
end

endmodule