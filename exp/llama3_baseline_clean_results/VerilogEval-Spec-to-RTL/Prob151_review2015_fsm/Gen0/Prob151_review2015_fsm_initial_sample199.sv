module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [3:0] state;
reg [3:0] count;
reg pattern_detected;

// States
parameter IDLE = 4'b0000;
parameter PATTERN_DETECT = 4'b0001;
parameter SHIFT = 4'b0010;
parameter COUNTING = 4'b0011;
parameter DONE_STATE = 4'b0100;
parameter ACKNOWLEDGED = 4'b0101;

// Pattern detection
reg [3:0] pattern;
always @(posedge clk) begin
    if (reset) begin
        pattern <= 4'b0000;
    end else if (data) begin
        pattern <= {pattern[2:0], 1'b1};
    end else begin
        pattern <= {pattern[2:0], 1'b0};
    end
end

// Finite-state machine
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        count <= 4'b0000;
        pattern_detected <= 1'b0;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (pattern == 4'b1101) begin
                    state <= PATTERN_DETECT;
                    pattern_detected <= 1'b1;
                end else begin
                    state <= IDLE;
                    pattern_detected <= 1'b0;
                end
            end
            PATTERN_DETECT: begin
                state <= SHIFT;
                shift_ena <= 1'b1;
            end
            SHIFT: begin
                if (count == 4'b0100) begin
                    state <= COUNTING;
                    count <= 4'b0000;
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                end else begin
                    count <= count + 1'b1;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    state <= DONE_STATE;
                    counting <= 1'b0;
                    done <= 1'b1;
                end else begin
                    state <= COUNTING;
                end
            end
            DONE_STATE: begin
                if (ack) begin
                    state <= ACKNOWLEDGED;
                    done <= 1'b0;
                end else begin
                    state <= DONE_STATE;
                end
            end
            ACKNOWLEDGED: begin
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule